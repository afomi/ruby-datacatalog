require File.dirname(__FILE__) + '/spec_helper'

describe DataCatalog::User do
  
  before(:each) do
    setup_api
    clean_slate
  end

  describe ".all" do
    
    it "should return an array of users" do
      users = DataCatalog::User.all
      users.should be_an_instance_of(Array)
      users.first.should be_an_instance_of(DataCatalog::User)
      users.first.email.should eql("ndc@sunlightlabs.com")
    end
    
  end # describe ".all"

  describe ".create" do
    
    it "should create a new user when valid params are passed in" do
      valid_params = {:name => "John Smith", :email => "john@johnsmith.com"}
      
      user = DataCatalog::User.create(valid_params)
      valid_params.each do |key, value|
        user.send(key).should eql(value)
      end
    end

    it "should raise BadRequest when invalid params are passed in" do
      invalid_params = {:garbage_field => "junk"}
      executing { DataCatalog::User.create(invalid_params) }.should raise_error(DataCatalog::BadRequest)
    end
    
  end # describe ".create"
  
  describe ".find" do
    
    it "should return a user" do  
      new_user = DataCatalog::User.create(:email => "jack@email.com")
      
      user = DataCatalog::User.find(new_user.id)
      user.should be_an_instance_of(DataCatalog::User)
      user.email.should eql("jack@email.com")
    end
    
    it "should raise NotFound out if no user exists" do
      executing { DataCatalog::User.find('badid') }.should raise_error(DataCatalog::NotFound)
    end
    
  end # describe ".find"
  
  describe ".find_by_api_key" do
    
    it "should return a user" do
      new_user = DataCatalog::User.create(:email => "johann@email.com")
      
      user = DataCatalog::User.find_by_api_key(new_user.primary_api_key)
      user.should be_an_instance_of(DataCatalog::User)
      user.email.should eql("johann@email.com")
    end

  end # describe ".find_by_api_key"
    
  describe ".update" do
    
    it "should update a user when valid params are passed in" do
      valid_params = { :name => "Jane Smith" }
      new_user = DataCatalog::User.create(:name => "Joan Smith", :email => "jane@email.com")
      
      user = DataCatalog::User.update(new_user.id, valid_params)
      user.name.should eql("Jane Smith")
    end

    it "should raise BadRequest when invalid params are passed in" do
      invalid_params = { :garbage => "junk" }
      
      user = DataCatalog::User.create(:name => "Ted Smith", :email => "ted@email.com")
      executing { DataCatalog::User.update(user.id, invalid_params) }.should raise_error(DataCatalog::BadRequest)
    end

  end # describe ".update"
  
  describe ".destroy" do
    
    it "should destroy an existing user" do
      user = DataCatalog::User.create(:name => "Dead Man", :email => "deadman@email.com")

      result = DataCatalog::User.destroy(user.id)
      result.should be_true
    end
    
    it "should raise NotFound when non-existing user" do
      user_id = "000000000000000000000000"
      executing { DataCatalog::User.destroy(user_id) }.should raise_error(DataCatalog::NotFound)
    end
    
  end # describe ".destroy"

  describe "#generate_api_key!" do
  
    it "should generate a new key for the user" do
      user = DataCatalog::User.create(:name => "Sally", :email => "sally@email.com")

      valid_params = { :purpose => "Civic hacking with my awesome app", :key_type => "application" }
      user.generate_api_key!(valid_params).should be_true
      user.api_keys.length.should eql(2)
      user.api_keys[1][:purpose].should eql("Civic hacking with my awesome app")
      
      user.application_api_keys.length.should eql(1)
    end
    
    it "should raise BadRequest when attempting to create a primary key" do
      user = DataCatalog::User.create(:name => "Sally", :email => "sally@email.com")

      invalid_params = { :purpose => "Civic hacking with my awesome app", :key_type => "primary" }
      executing { user.generate_api_key!(invalid_params)}.should raise_error(DataCatalog::BadRequest)
    end
    
  end # describe "#generate_api_key!"
  
  describe "#update_api_key!" do
  
    it "should update a key for the user" do      
      user = DataCatalog::User.create(:name => "Sally", :email => "sally@email.com")
      key_params1 = { :purpose => "Civic hacking with my awesome app", :key_type => "application" }
      user.generate_api_key!(key_params1).should be_true

      key_params2 = { :key_type => "valet", :purpose => "To be more awesome" }
      user.update_api_key!(user.api_keys[1].id, key_params2).should be_true
      user.api_keys.length.should eql(2)
      user.api_keys[1].purpose.should eql("To be more awesome")
    end
    
    it "should raise NotFound if updating a key that doesn't exist" do
      user = DataCatalog::User.create(:name => "Sally", :email => "sally@email.com")    
      executing { user.update_api_key!('asdjldjkf', {}) }.should raise_error(DataCatalog::NotFound)
    end

    it "should raise BadRequest if primary key's type is changed" do
      user = DataCatalog::User.create(:name => "Sally", :email => "sally@email.com")    
      executing { user.update_api_key!(user.api_keys[0].id, {:key_type => "valet"}) }.should raise_error(DataCatalog::BadRequest)
    end
  
  end # describe "#update_api_key!"

  describe "#delete_api_key!" do
    
    it "should delete a key for the user" do
      user = DataCatalog::User.create(:name => "Sally", :email => "sally@email.com")
      key_params = { :purpose => "Civic hacking with my awesome app", :key_type => "application" }
      user.generate_api_key!(key_params).should be_true
    
      user.delete_api_key!(user.api_keys[1].id).should be_true
      user.api_keys.length.should eql(1)
    end
    
    it "should raise Conflict if deleting the primary key" do
      user = DataCatalog::User.create(:name => "Sally", :email => "sally@email.com")  
      executing { user.delete_api_key!(user.api_keys[0].id) }.should raise_error(DataCatalog::Conflict)
    end
    
  end # describe "#delete_api_key!"
  
end
