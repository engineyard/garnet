class Garnet::Dependency
  include DataMapper::Resource

  property :id, Serial
  property :requirements, String
  property :scope, String

  belongs_to :stone
  belongs_to :cut

  def self.development
    all(:scope => :development)
  end

  def self.runtime
    all(:scope => :runtime)
  end
end
