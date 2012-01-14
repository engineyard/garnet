require 'spec_helper'

describe Garnet::Api::Gems do
  let(:gem_name){ "sinatra" } # it works cause its a dependency
  let(:gem_spec) { Gem::Specification.find_by_name(gem_name) }
  let(:gem) { File.read(gem_spec.cache_file) }
  let(:user) { Garnet::User.create(:email => "lane.joshlane@gmail.com") }
  let(:client) do
    Garnet::Api::Gems.set :show_exceptions, false
    Garnet::Api::Gems.set :raise_errors, true
    token = user.token
    Rack::Client.new do 
      use Rack::Config do |env|
        env['HTTP_AUTHORIZATION'] = token
      end
      run Garnet::Api::Gems
    end
  end

  it "should create a gem" do
    response = client.post("/api/v1/gems/", { 'Content-Type' => 'application/octet-stream' }, gem)
    response.should be_successful
    ggem = Garnet::Stone.last
    ggem.name.should == gem_name
    ggem.versions.size.should == 1
    ggem.versions.last.number.should == Sinatra::VERSION
  end

  it "should retrieve a created gem" do
    client.post("/api/v1/gems", { 'Content-Type' => 'application/octet-stream' }, gem).should be_successful
    response = client.get("/api/v1/gems")
    ggem = Garnet::Stone.last
    MultiJson.decode(response.body).should == [ggem.payload]
  end

  it "should get a gems owners" do
    response = client.post("/api/v1/gems", { 'Content-Type' => 'application/octet-stream' }, gem)
    response = client.get("/api/v1/gems/#{gem_name}/owners")
    response.should be_successful
    MultiJson.decode(response.body).should == [{"email" => user.email}]
  end
end
