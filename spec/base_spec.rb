require File.dirname(__FILE__) + '/spec_helper'

describe DataCatalog do

  describe "module accessors" do

    it "should access the API Key" do
      DataCatalog.api_key = 'flurfeneugen'
      DataCatalog.api_key.should == 'flurfeneugen'
    end

    it "should access the base URI" do
      DataCatalog.base_uri = 'somehost.com'
      DataCatalog.base_uri.should == 'somehost.com'
    end
  
  end # describe "accessors"

end

describe DataCatalog::Base do

  before(:each) { setup_api }

  describe "::set_base_uri" do

    it "should set and normalize the base URI" do
      DataCatalog.base_uri = 'notherhost.com'
      DataCatalog::Base.set_base_uri
      DataCatalog::Base.default_options[:base_uri].should == 'http://notherhost.com'
    end
    
    it "should set the base URI to the default if it's not explicitly defined" do
      DataCatalog.base_uri = nil
      DataCatalog::Base.set_base_uri
      DataCatalog::Base.default_options[:base_uri].should == 'http://api.nationaldatacatalog.com'
    end
  
  end # describe "::set_base_uri"
  
  describe "::set_api_key" do

    it "should set the API key" do
      DataCatalog::Base.set_api_key
      DataCatalog::Base.default_options[:default_params].should include(:api_key => 'flurfeneugen')
    end

    it "should raise exception when attempting to set the API key but none is set" do
      DataCatalog.api_key = nil
      executing { DataCatalog::Base.set_api_key }.should raise_error(DataCatalog::ApiKeyUndefined)
    end
    
  end # describe "::set_default_params"

  describe "::set_up!" do
    
    it "should set both the base URI and API key" do
      DataCatalog::Base.set_up!
      DataCatalog::Base.default_options[:base_uri].should == 'http://somehost.com'
      DataCatalog::Base.default_options[:default_params].should include(:api_key => 'flurfeneugen')
    end
    
  end # describe "::set_up!"
  
  describe "::build_object" do
    
    it "should create an object when a filled hash is passed in" do
      base_object = DataCatalog::Base.build_object(:name => "John Smith", :email => "john@email.com")
      base_object.should be_an_instance_of(DataCatalog::Base)
      base_object.email.should eql("john@email.com")
    end
    
    it "should return nil when an empty hash is passed in" do
      base_object = DataCatalog::Base.build_object({})
      base_object.should be_nil
    end
    
    it "should return nil when nil is passed in" do
      base_object = DataCatalog::Base.build_object(nil)
      base_object.should be_nil
    end
    
  end # describe "::build_object!"

  describe "::about" do

    it "should return information about the API" do
      mock(DataCatalog::Base).get("/") { mock_response_for(:get, '/') }
      base_object = DataCatalog::Base.about
      base_object.should be_an_instance_of(DataCatalog::Base)
      base_object.name.should eql("National Data Catalog API")
    end

  end # describe "::about"
  
  describe "#id" do
    
    it "should return the proper id (not object_id)" do
      base_object = DataCatalog::Base.new(:id => "4b9630f54a8eb69c00000001")
      base_object.id.should eql("4b9630f54a8eb69c00000001")
    end
    
  end # describe "#id"

end