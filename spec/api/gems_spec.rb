require 'spec_helper'

describe Garnet::Api::Gems do
  let(:client) do
    Garnet::Api::Gems.set :show_exceptions, false
    Garnet::Api::Gems.set :raise_errors, true
    Rack::Client.new { run Garnet::Api::Gems }
  end
  let(:gem) do
    File.read(Gem::Specification.find_by_name("sinatra").cache_file)
  end

  it "should create a gem" do
    response = client.post("/api/v1/gems/", { 'Content-Type' => 'application/octet-stream' }, gem)
    response.should be_successful
    gem = Garnet::Gem.last
    gem.name.should == "sinatra"
    gem.versions.last.version.should == Sinatra::VERSION
  end
end
