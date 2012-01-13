require 'spec_helper'

describe Garnet::Api::Gems do
  let(:client) do
    Garnet::Api::Gems.set :show_exceptions, false
    Garnet::Api::Gems.set :raise_errors, true
    Rack::Client.new { run Garnet::Api::Gems }
  end
  let(:gem_name){ "sinatra" } # it works cause its a dependency
  let(:gem) do
    File.read(Gem::Specification.find_by_name(gem_name).cache_file)
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
end
