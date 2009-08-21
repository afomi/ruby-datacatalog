require File.dirname(__FILE__) + '/spec_helper'

describe DataCatalog::User do

  describe "::all" do
    
    it "should return an array of users" do
      mock(DataCatalog::User).get("/users") { mock_response_for(:get, '/users') }
      users = DataCatalog::User.all
      users.should be_an_instance_of(Array)
      users.first.should be_an_instance_of(DataCatalog::User)
      users.first.email.should eql("ndc@sunlightlabs.com")
    end
    
  end # describe "#all"
  
  describe "::find" do
    
    it "should return a user" do
      mock(DataCatalog::User).get("/users/someid") { mock_response_for(:get, '/users/someid') }
      user = DataCatalog::User.find('someid')
      user.should be_an_instance_of(DataCatalog::User)
      user.email.should eql("ndc@sunlightlabs.com")
    end
    
    it "should raise ResourceNotFound out if no user exists" do
      mock(DataCatalog::User).get("/users/badid") { mock_response_for(:get, '/users/badid', 404) }
      executing { DataCatalog::User.find('badid') }.should raise_error(DataCatalog::ResourceNotFound)
    end
    
  end # describe "#find"
  
  describe "::create" do
    
    it "should create a new user when valid params are passed in" do
      valid_params = {:name => "National Data Catalog", :email => "ndc@sunlightlabs.com", :purpose => "To be awesome."}
      mock(DataCatalog::User).post("/users", :query => valid_params) { mock_response_for(:post, '/users') }
      user = DataCatalog::User.create(valid_params)
      valid_params.each do |key, value|
        user.send(key).should eql(value)
      end
    end

    it "should raise BadRequest when invalid params are passed in" do
      invalid_params = {:garbage_field => "junk"}
      mock(DataCatalog::User).post("/users", :query => invalid_params) { mock_response_for(:post, '/users', 400) }
      executing { DataCatalog::User.create(invalid_params) }.should raise_error(DataCatalog::BadRequest)
    end
    
  end # describe "#create"
  
  describe "::update" do
    
    it "should update a user when valid params are passed in" do
      user_id = "4b9630f54a8eb69c00000001"
      valid_params = { :name => "Mr. Updated" }
      mock(DataCatalog::User).put("/users/#{user_id}", :query => valid_params) do 
        parsed_body = {
          "admin"              => true,
          "created_at"         => "2009/08/17 16:07:17 +0000",
          "creator_api_key"    => nil,
          "email"              => "ndc@sunlightlabs.com",
          "id"                 => "4b9630f54a8eb69c00000001",
          "name"               => "Mr. Updated",
          "primary_api_key"    => "6bc4fd27816d05b2e39886a9e6c5472b8264c8de",
          "purpose"            => nil,
          "secondary_api_keys" => [], 
          "updated_at"         => "2009/08/17 16:07:17 +0000",
        }
        HTTParty::Response.new(parsed_body, parsed_body.to_json, 200, "OK", {})
      end
      user = DataCatalog::User.update(user_id, valid_params)
      user.name.should eql("Mr. Updated")
    end

    it "should raise BadRequest when invalid params are passed in" do
      user_id = "4b9630f54a8eb69c00000001"
      invalid_params = { :name => "Mr. Updated" }
      mock(DataCatalog::User).put("/users/#{user_id}", :query => invalid_params ) do 
        parsed_body = {
          "admin"              => true,
          "created_at"         => "2009/08/17 16:07:17 +0000",
          "creator_api_key"    => nil,
          "email"              => "ndc@sunlightlabs.com",
          "id"                 => "4b9630f54a8eb69c00000001",
          "name"               => "Mr. Updated",
          "primary_api_key"    => "6bc4fd27816d05b2e39886a9e6c5472b8264c8de",
          "purpose"            => nil,
          "secondary_api_keys" => [], 
          "updated_at"         => "2009/08/17 16:07:17 +0000",
        }
        HTTParty::Response.new(parsed_body, parsed_body.to_json, 400, "Bad Request", {})
      end
      executing do
        DataCatalog::User.update(user_id, invalid_params)
      end.should raise_error(DataCatalog::BadRequest)
    end
  
  end
  
end
