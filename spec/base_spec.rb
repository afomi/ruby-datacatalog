require File.dirname(__FILE__) + '/spec_helper'

describe DataCatalog do

  context "module accessors" do

    it "should access the API Key" do
      DataCatalog.api_key = 'flurfeneugen'
      DataCatalog.api_key.should == 'flurfeneugen'
    end

    it "should access the base URI" do
      DataCatalog.base_uri = 'somehost.com'
      DataCatalog.base_uri.should == 'somehost.com'
    end
  
  end # context "accessors"

end

describe DataCatalog::Base do

  before(:each) do
    DataCatalog.api_key = 'flurfeneugen'
    DataCatalog.base_uri = 'somehost.com'
  end

  context "#set_base_uri" do

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
  
  end # context "#set_base_uri"
  
  context "#set_default_params" do

    it "should set the API key" do
      DataCatalog::Base.set_default_params
      DataCatalog::Base.default_options[:default_params].should include(:api_key => 'flurfeneugen')
    end

    it "should raise exception when attempting to set the API key but none is set" do
      DataCatalog.api_key = nil
      executing { DataCatalog::Base.set_default_params }.should raise_error("Failed to provide API Key!")
    end
    
  end # context "#set_default_params"

  context "#set_up!" do
    
    it "should set both the base URI and API key" do
      DataCatalog::Base.set_up!
      DataCatalog::Base.default_options[:base_uri].should == 'http://somehost.com'
      DataCatalog::Base.default_options[:default_params].should include(:api_key => 'flurfeneugen')
    end
    
  end # context "#set_up!"

  context "#about" do
    
    it "should return information about the API" do
      mock(DataCatalog::Base).get("/") { {:name => "National Data Catalog API"} }
      DataCatalog::Base.about.should include(:name => "National Data Catalog API")
    end
    
  end # context "#about"

end