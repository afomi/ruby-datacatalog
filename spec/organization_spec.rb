require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Organization do

  def create_3_organizations
    @organization_names = ["Federal Communications Commission", "Federal Election Commission", "Department of State"]
    @organization_names.each do |name|
      Organization.create(:name => name, :org_type => "governmental")
    end
  end

  before do
    setup_api
    clean_slate
  end
  
  describe ".all" do
    
    before do
      create_3_organizations
    end
    
    it "should return an enumeration of Organizations" do
      @organizations = Organization.all
      @organizations.each do |o|
        o.should be_an_instance_of(Organization)
      end
    end
    
    it "should return an enumeration with organization name set" do
      @organizations = Organization.all
      @organizations.map(&:name).sort.should == @organization_names.sort
    end
    
    it "should return the matching organizations when options are passed in" do
      @organizations = Organization.all(:name => "Federal Communications Commission")
      @organizations.map(&:name).should == ["Federal Communications Commission"]
    end
    
  end # describe ".all"

  describe ".first" do
    
    before do
      create_3_organizations
    end
    
    it "should return the matching organization when options are passed in" do
      @organization = Organization.first(:name => "Federal Communications Commission")
      @organization.name.should == "Federal Communications Commission"
    end
    
  end # describe ".first"
  
  describe ".get" do

    before do
      @organization = Organization.create(:name => "Federal Election Commission", :org_type => "governmental")
    end

    it "should return an organization" do
      organization = Organization.get(@organization.id)
      organization.should be_an_instance_of(Organization)
      organization.name.should == "Federal Election Commission"
    end
    
    it "should raise NotFound if no source exists" do
      executing do
        Organization.get(mangle(@organization.id))
      end.should raise_error(NotFound)
    end
    
  end # describe ".get"

  describe ".create" do
    
    it "should create a new organization when valid params are passed in" do
      @organization = Organization.create(:name => "Federal Communications Commission", :org_type => "governmental")
      @organization.should be_an_instance_of(Organization)
      @organization.name.should == "Federal Communications Commission"
    end
    
    it "should raise BadRequest when a bad URL is passed in" do
      executing do 
        Organization.create(:name => "Bad Org", :url => "htt:p//jlkj!3", :org_type => "governmental")
      end.should raise_error(BadRequest)
    end

  end # describe ".create"

  describe ".update" do

    before do
      @organization = Organization.create(:name => "Federal Election Commission", :org_type => "governmental")
    end
  
    it "should update an existing organization from valid params" do
      organization = Organization.update(@organization.id, { :url => "http://fec.gov/" })
      organization.should be_an_instance_of(Organization)
      organization.url.should == "http://fec.gov/"
    end
    
  end # describe ".update" 

  describe ".destroy" do

    before do
      @organization = Organization.create(:name => "Federal Election Commission", :org_type => "governmental")
    end
  
    it "should destroy an existing organization" do
      Organization.destroy(@organization.id).should be_true
    end
    
    it "should raise NotFound when attempting to destroy non-existing organization" do
      executing do
        Organization.destroy(mangle(@organization.id))
      end.should raise_error(NotFound)
    end
    
  end # describe ".destroy"

end