require File.dirname(__FILE__) + '/spec_helper'

describe DataCatalog::User do

  describe "#all" do
    
    it "should return an array of users" do
      mock(DataCatalog::User).get("/users") { mock_response_for(:get, '/users') }
      users = DataCatalog::User.all
      users.should be_an_instance_of(Array)
      users.first.should be_an_instance_of(DataCatalog::User)
      users.first.email.should eql("ndc@sunlightlabs.com")
    end
    
  end # describe "#all"
  
  describe "#find" do
    
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
  
  describe "#create" do
    
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
  
end
