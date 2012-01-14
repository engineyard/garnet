class Garnet::Stone
  include DataMapper::Resource

  HOST="http://garnet.dev/" # FIXME: need to dynamically set this based on the request

  property :id, Serial
  property :name, String
  
  # Links
  property :homepage_uri, String
  property :wiki_uri, String
  property :documentation_uri, String
  property :mailing_list_uri, String
  property :source_code_uri, String
  property :bug_tracker_uri, String

  has n, :cuts
  alias_method :versions, :cuts
  has n, :ownerships
  has n, :owners, :through => :ownerships, :via => :user, :model => "Garnet::User"

  validates_uniqueness_of :name

  def self.from(name)
    Garnet::Stone.first(:name => name)
  end

  def self.push(gem_io, owners)
    spec = Gem::Package.open gem_io, "r", nil do |pkg|
      pkg.metadata
    end
    stone = first_or_create(:name => spec.name)
    stone.update(:owners => owners)
    stone.cuts.create(:number => spec.version)
  end

  def to_json(*args)
    payload
  end

  def to_yaml(*args)
    payload
  end

  def downloads
    cuts.map{|v| v.downloads}.inject(0){|r,e| r += e}
  end

  def payload(version=cuts.most_recent, host_with_port=HOST)
    {
      'name'              => name,
      'downloads'         => downloads,
      'version'           => version.number,
      'version_downloads' => version.downloads,
      'authors'           => version.authors,
      'info'              => version.info,
      'project_uri'       => "http://#{host_with_port}/gems/#{name}",
      'gem_uri'           => "http://#{host_with_port}/gems/#{version.full_name}.gem",
      'homepage_uri'      => homepage_uri,
        'wiki_uri'          => wiki_uri,
        'documentation_uri' => documentation_uri,
        'mailing_list_uri'  => mailing_list_uri,
        'source_code_uri'   => source_code_uri,
        'bug_tracker_uri'   => bug_tracker_uri,
        'dependencies'      => {
          'development' => version.dependencies.development.to_a,
          'runtime'     => version.dependencies.runtime.to_a
      }
    }
  end
end
