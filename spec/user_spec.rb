require File.dirname(__FILE__) + '/spec_helper'

describe DataCatalog::User do
  
  before(:each) { setup_api }

  describe ".all" do
    
    it "should return an array of users" do
      mock(DataCatalog::User).get("/users") { mock_response_for(:get, '/users') }
      users = DataCatalog::User.all
      users.should be_an_instance_of(Array)
      users.first.should be_an_instance_of(DataCatalog::User)
      users.first.email.should eql("ndc@sunlightlabs.com")
    end
    
  end # describe ".all"
  
  describe ".find" do
    
    it "should return a user" do
      mock(DataCatalog::User).get("/users/someid") { mock_response_for(:get, '/users/someid') }
      mock(DataCatalog::User).get("/users/someid/keys") { mock_response_for(:get, '/users/someid/keys') }
      
      user = DataCatalog::User.find('someid')
      user.should be_an_instance_of(DataCatalog::User)
      user.email.should eql("ndc@sunlightlabs.com")
    end
    
    it "should raise NotFound out if no user exists" do
      mock(DataCatalog::User).get("/users/badid") { mock_response_for(:get, '/users/badid', 404) }
      executing { DataCatalog::User.find('badid') }.should raise_error(DataCatalog::NotFound)
    end
    
  end # describe ".find"
  
  describe ".create" do
    
    it "should create a new user when valid params are passed in" do
      valid_params = {:name => "National Data Catalog", :email => "ndc@sunlightlabs.com"}
      mock(DataCatalog::User).post("/users", :query => valid_params) { mock_response_for(:post, '/users') }
      mock(DataCatalog::User).get("/users/someid/keys") { mock_response_for(:get, '/users/someid/keys') }
      
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
    
  end # describe ".create"
  
  describe ".update" do
    
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

  end # describe ".update"
  
  describe ".destroy" do
    
    it "should destroy an existing user" do
      user_id = "4b9630f54a8eb69c00000001"
      mock(DataCatalog::User).delete("/users/#{user_id}") do 
        parsed_body = { "id" => user_id }
        HTTParty::Response.new(parsed_body, parsed_body.to_json, 200, "OK", {})
      end
      result = DataCatalog::User.destroy(user_id)
      result.should be_true
    end
    
    it "should raise NotFound when non-existing user" do
      user_id = "000000000000000000000000"
      mock(DataCatalog::User).delete("/users/#{user_id}") do 
        parsed_body = {}
        HTTParty::Response.new(parsed_body, parsed_body.to_json, 404, "Not Found", {})
      end
      executing { DataCatalog::User.destroy(user_id) }.should raise_error(DataCatalog::NotFound)
    end

    it "should raise Error upon unexpected status code" do
      user_id = "000000000000000000000000"
      mock(DataCatalog::User).delete("/users/#{user_id}") do 
        parsed_body = {}
        HTTParty::Response.new(parsed_body, parsed_body.to_json, 503, "Service Unavailable", {})
      end
      executing { DataCatalog::User.destroy(user_id) }.should raise_error(DataCatalog::Error)
    end
    
  end # describe ".destroy"

  describe "#generate_api_key!" do
  
    it "should generate a new key for the user" do
      valid_user_params = {:name => "National Data Catalog", :email => "ndc@sunlightlabs.com"}
      mock(DataCatalog::User).post("/users", :query => valid_user_params) { mock_response_for(:post, '/users') }
      mock(DataCatalog::User).get("/users/someid/keys") { mock_response_for(:get, '/users/someid/keys') }
    
      user = DataCatalog::User.create(valid_user_params)  
      valid_params = { :purpose => "Civic hacking with my awesome app", :key_type => "application" }
      mock(DataCatalog::User).post("/users/#{user.id}/keys", :query => valid_params) do 
        parsed_body = {
          :api_key     => "123456789",
          :purpose     => "Civic hacking with my awesome app",
          :application => "application",
          :created_at  => Time.now.to_s
        }
        HTTParty::Response.new(parsed_body, parsed_body.to_json, 200, "OK", {})
      end
      mock(DataCatalog::User).get("/users/someid/keys") { mock_response_for(:get, '/users/someid2/keys') }
    
      user.generate_api_key!(valid_params).should be_true
      user.api_keys.length.should eql(2)
      user.api_keys[1][:purpose].should eql("Civic hacking with my awesome app")
    end
    
  end # describe "#generate_api_key!"
  
  describe "#update_api_key!" do
  
    it "should update a key for the user" do
      valid_user_params = {:name => "National Data Catalog", :email => "ndc@sunlightlabs.com"}
      mock(DataCatalog::User).post("/users", :query => valid_user_params) { mock_response_for(:post, '/users') }
      mock(DataCatalog::User).get("/users/someid/keys") { mock_response_for(:get, '/users/someid2/keys') }
      user = DataCatalog::User.create(valid_user_params)
    
      key_params = { :key_type => "valet", :purpose => "To be more awesome" }
      mock(DataCatalog::User).put("/users/someid/keys/keyid", :query => key_params) { mock_response_for(:put, '/users/someid/keys/keyid') }
      mock(DataCatalog::User).get("/users/someid/keys") { mock_response_for(:get, '/users/someid-valet/keys') }

      user.update_api_key!("keyid", key_params).should be_true
      user.api_keys.length.should eql(2)
      user.api_keys[1].purpose.should eql("To be more awesome")
    end
  
  end # describe "#update_api_key!"

  describe "#delete_api_key!" do
    
    it "should delete a key for the user" do
      valid_user_params = {:name => "National Data Catalog", :email => "ndc@sunlightlabs.com"}
      mock(DataCatalog::User).post("/users", :query => valid_user_params) { mock_response_for(:post, '/users') }
      mock(DataCatalog::User).get("/users/someid/keys").times(2) { mock_response_for(:get, '/users/someid/keys') }
      user = DataCatalog::User.create(valid_user_params)  
    
      mock(DataCatalog::User).delete("/users/someid/keys/keyid") { mock_response_for(:delete, "/users/someid/keys/keyid") }
      user.delete_api_key!("keyid").should be_true
      user.api_keys.length.should eql(1)
    end
    
  end # describe "#delete_api_key!"
  
end
