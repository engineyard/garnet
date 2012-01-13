class Garnet::Cut
  include DataMapper::Resource

  property :id, Serial
  property :number, String
  property :downloads, Integer, :default => 0
  property :info, String

  belongs_to :stone
  has n, :authors
  has n, :dependencies

  def self.most_recent
    all(:order => [:number.desc]).first
  end

  def full_name
    "#{stone.name}-#{self.number}"
  end
end
