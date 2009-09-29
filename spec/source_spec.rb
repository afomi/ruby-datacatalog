require File.dirname(__FILE__) + '/spec_helper'

describe DataCatalog::Source do
  
  before(:each) do
    setup_api
    clean_slate
  end

  describe ".all" do
    before do
      %w(FCC NASA DOE).each do |name|
        DataCatalog::Source.create({
          :title => "#{name} Data",
          :url   => "http://#{name.downcase}.gov/data.xml"
        })
      end
      @sources = DataCatalog::Source.all
    end
    
    it "should return an enumeration of sources" do
      @sources.each do |source|
        source.should be_an_instance_of(DataCatalog::Source)
      end
    end
    
    it "should return correct titles" do
      expected = ["FCC Data", "NASA Data", "DOE Data"]
      @sources.map(&:title).sort.should == expected.sort
    end
    
  end # describe ".all"
  
  describe ".create" do
    
    it "should create a new source when valid params are passed in" do
      source = DataCatalog::Source.create({
        :title => "Some FCC Data",
        :url   => "http://fcc.gov/somedata.csv"
      })
      source.should be_an_instance_of(DataCatalog::Source)
      source.url.should eql("http://fcc.gov/somedata.csv")
    end
    
  end # describe ".all"
  
  describe ".update" do
    
    it "should update an existing source when valid params are passed in" do
      new_source = DataCatalog::Source.create({
        :title => "Some FCC Data",
        :url   => "http://fcc.gov/somedata.csv"
      })
      source = DataCatalog::Source.update(new_source.id, {
        :url => "http://fec.gov/newdata.csv"
      })
      source.should be_an_instance_of(DataCatalog::Source)
      source.url.should eql("http://fec.gov/newdata.csv")
    end
    
  end # describe ".all"  
  
  describe ".destroy" do
    
    it "should destroy an existing source" do
      source = DataCatalog::Source.create({
        :title => "Some FCC Data",
        :url   => "http://fcc.gov/somedata.csv"
      })
      result = DataCatalog::Source.destroy(source.id)
      result.should be_true
    end
    
    it "should raise NotFound when attempting to destroy non-existing source" do
      source_id = "000000000000000000000000"
      executing do
        DataCatalog::Source.destroy(source_id)
      end.should raise_error(DataCatalog::NotFound)
    end
    
  end # describe ".destroy"
  
end
