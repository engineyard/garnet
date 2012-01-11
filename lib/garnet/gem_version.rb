class Garnet::GemVersion
  include DataMapper::Resource

  property :id, Serial
  property :version, String

  belongs_to :gem
end
