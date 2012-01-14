require 'sinatra/base'
require 'dm-serializer'

class Garnet::Api::Gems < Sinatra::Base
  def respond_with(collection_or_entity)
    format = params[:format] || :json
    collection_or_entity.send("to_#{format}")
  end
  before do
    @current_user = Garnet::User.first(:token => request.env["HTTP_AUTHORIZATION"])
  end
#DELETE /api/v1/gems/yank(.:format)                            {:format=>/json|xml|yaml/, :action=>"yank", :controller=>"api/v1/rubygems"}
  delete "/api/v1/gems/yank.:format" do |format|
  end
#PUT    /api/v1/gems/unyank(.:format)                          {:format=>/json|xml|yaml/, :action=>"unyank", :controller=>"api/v1/rubygems"}
#GET    /api/v1/gems/latest(.:format)                          {:format=>/json|xml|yaml/, :action=>"latest", :controller=>"api/v1/rubygems"}
#GET    /api/v1/gems/just_updated(.:format)                    {:format=>/json|xml|yaml/, :action=>"just_updated", :controller=>"api/v1/rubygems"}
#POST   /api/v1/gems/:rubygem_id/owners(.:format)              {:format=>/json|xml|yaml/, :rubygem_id=>/[A-Za-z0-9\.\-_]+?/, :action=>"create", :controller=>"api/v1/owners"}
#GET    /api/v1/gems/:rubygem_id/owners(.:format)              {:format=>/json|xml|yaml/, :rubygem_id=>/[A-Za-z0-9\.\-_]+?/, :action=>"show", :controller=>"api/v1/owners"}
  get "/api/v1/gems/:name/owners/?.?:format?" do |name, format|
    stone = Garnet::Stone.from(name)
    respond_with(stone.owners)
  end
#DELETE /api/v1/gems/:rubygem_id/owners(.:format)              {:format=>/json|xml|yaml/, :rubygem_id=>/[A-Za-z0-9\.\-_]+?/, :action=>"destroy", :controller=>"api/v1/owners"}
  delete "/api/v1/gems/:name/owners/?.?:format?" do |name, format|
    stone = Garnet::Stone.from(name)
    if owner = stone.owners.first(:email => params[:email])
      if stone.ownerships.first(:user_id => owner.id).try(:destroy)
        "Owner removed successfully"
      else
      end
    end
  end
#GET    /api/v1/gems(.:format)                                 {:format=>/json|xml|yaml/, :action=>"index", :controller=>"api/v1/rubygems"}
  get "/api/v1/gems/?.?:format?" do |format|
    respond_with(Garnet::Stone.all)
  end
#POST   /api/v1/gems(.:format)                                 {:format=>/json|xml|yaml/, :action=>"create", :controller=>"api/v1/rubygems"}
  post "/api/v1/gems/?.?:format?" do
    Garnet::Stone.push(request.body, [@current_user])
  end
#GET    /api/v1/gems/:id(.:format)                             {:id=>/[A-Za-z0-9\.\-_]+?/, :format=>/json|xml|yaml/, :action=>"show", :controller=>"api/v1/rubygems"}
  get "/api/v1/gems/:id.:format" do |id, format|
  end
end
