require 'spec_helper'

describe Garnet::Api::Gems do
  let(:gem_name){ "sinatra" } # it works cause its a dependency
  let(:gem_spec) { Gem::Specification.find_by_name(gem_name) }
  let(:gem) { File.read(gem_spec.cache_file) }
  let(:user) { Garnet::User.make.tap{|u| u.save} }
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

  describe "#owners" do
    before(:each) { client.post("/api/v1/gems", { 'Content-Type' => 'application/octet-stream' }, gem) }
    it "should get owners" do
      response = client.get("/api/v1/gems/#{gem_name}/owners")
      response.should be_successful
      MultiJson.decode(response.body).should == [{"email" => user.email}]
    end

    it "should add an owner" do
      new_user = Garnet::User.make!
      response = client.post("/api/v1/gems/#{gem_name}/owners", {}, {:email => new_user.email})
      response.should be_successful
      response.body.should == "Owner added successfully"
      response = client.get("/api/v1/gems/#{gem_name}/owners")
      MultiJson.decode(response.body).map{|i| i["email"]}.sort.should == [new_user.email, user.email].sort
    end
  end
end
