class Garnet::User
  include DataMapper::Resource

  TOKEN_CHARS = (('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a).freeze
  TOKEN_SIZE  = 16.freeze

  property :id, Serial
  property :name, String
  property :email, String
  property :token, String, :default => TOKEN_SIZE.times.inject(""){|r,e| r << TOKEN_CHARS[rand(TOKEN_CHARS.size)]}

  validates_uniqueness_of :email, :token
  validates_presence_of :name, :email, :token

  has n, :ownerships
  has n, :stones, :through => :ownerships

  def payload
    {"email" => self.email}
  end

  def to_json(*args)
    payload
  end
end
