class Garnet::Ownership
  include DataMapper::Resource

  property :id, Serial

  belongs_to :user
  belongs_to :stone
end
