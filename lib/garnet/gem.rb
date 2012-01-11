class Garnet::Gem
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :gem_versions

  alias_method :versions, :gem_versions

  def self.push(gem_io)
    spec = Gem::Package.open gem_io, "r", nil do |pkg|
      pkg.metadata
    end
    gem = Garnet::Gem.first_or_create(:name => spec.name)
    gem.versions.create(:version => spec.version)
  end
end
