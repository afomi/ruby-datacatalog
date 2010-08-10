require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe DataCatalog do

  describe ".about" do
    before do
      setup_api
    end

    it "should return information about the API" do
      about = About.get
      about.should be_an_instance_of(About)
      about.name.should == "National Data Catalog API"
      about.project_page.should == {
        "href" => "http://sunlightlabs.com/projects/datacatalog/"
      }
    end
  end

  describe ".version_at_least?" do
    it "should return false if below the actual version" do
      version_mock = mock(Object.new).version { '1.0.0' }
      mock(About).get { version_mock }
      About.version_at_least?('1.1.1').should be false
    end

    it "should return true if at the actual version" do
      version_mock = mock(Object.new).version { '1.0.0' }
      mock(About).get { version_mock }
      About.version_at_least?('1.0.0').should be true
    end

    it "should return true if above the actual version" do
      version_mock = mock(Object.new).version { '1.0.0' }
      mock(About).get { version_mock }
      About.version_at_least?('0.9.9').should be true
    end
  end

end
