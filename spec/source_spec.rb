require File.dirname(__FILE__) + '/spec_helper'

describe DataCatalog::Source do
  
  before(:each) do
    setup_api
    clean_slate
  end

  describe ".all" do
    
    it "should return an array of sources" do
      sources = DataCatalog::Source.all
      sources.should be_an_instance_of(Array)
      #sources.first.should be_an_instance_of(DataCatalog::Source)
    end
    
  end # describe ".all"
  
  describe ".create" do
    
    it "should create a new source when valid params are passed in" do
      source = DataCatalog::Source.create({:title => "Some FCC Data", :url => "http://fcc.gov/somedata.csv"})
      source.should be_an_instance_of(DataCatalog::Source)
      source.url.should eql("http://fcc.gov/somedata.csv")
    end
    
  end # describe ".all"
  
  describe ".update" do
    
    it "should update an existing source when valid params are passed in" do
      new_source = DataCatalog::Source.create(:title => "Some FCC Data", :url => "http://fcc.gov/somedata.csv")
      
      source = DataCatalog::Source.update(new_source.id, {:url => "http://fec.gov/newdata.csv"})
      source.should be_an_instance_of(DataCatalog::Source)
      source.url.should eql("http://fec.gov/newdata.csv")
    end
    
  end # describe ".all"  
  
  describe ".destroy" do
    
    it "should destroy an existing source" do
      source = DataCatalog::Source.create(:title => "Some FCC Data", :url => "http://fcc.gov/somedata.csv")

      result = DataCatalog::Source.destroy(source.id)
      result.should be_true
    end
    
    it "should raise NotFound when attempting to destroy non-existing source" do
      source_id = "000000000000000000000000"
      executing { DataCatalog::Source.destroy(source_id) }.should raise_error(DataCatalog::NotFound)
    end
    
  end # describe ".destroy"
  
end