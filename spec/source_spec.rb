require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

module SourceHelpers
  def create_source(params={})
    valid_params = {
      :title       => "Some FCC Data",
      :url         => "http://fcc.gov/somedata.csv",
      :source_type => "dataset"
    }
    Source.create(valid_params.merge(params))
  end

  def create_3_sources
    %w(FCC NASA DOE).each do |name|
      Source.create({
        :title        => "#{name} Data",
        :url          => "http://#{name.downcase}.gov/data.xml",
        :source_type  => "dataset"
      })
    end
  end

  def create_30_sources
    (1..30).each do |n|
      Source.create({
        :title        => "Dataset #{n.to_s}",
        :url          => "http://awesome.gov/dataset#{n.to_s}.xml",
        :source_type  => "dataset"
      })
    end
  end
end

describe Source do
  include SourceHelpers

  before do
    setup_api
    clean_slate
  end

  describe ".all" do
    before do
      create_3_sources
      @sources = Source.all
    end

    it "should return an Enumerable object" do
      @sources.is_a?(Enumerable).should == true
    end

    it "should return an enumeration of sources" do
      @sources.each do |source|
        source.should be_an_instance_of(Source)
      end
    end

    it "should return correct titles" do
      expected = ["FCC Data", "NASA Data", "DOE Data"]
      @sources.map(&:title).sort.should == expected.sort
    end

    describe "with cursor" do
      it "should raise an error on bad index" do
        executing do
          @sources.page(0)
        end.should raise_error(RuntimeError)
      end

      it "should return 20 objects when there are more than 20" do
        create_30_sources
        sources = Source.all
        sources.size.should == 20
        sources.page(1).size.should == 20
        sources.page(2).size.should == 13
      end
    end
  end

  describe ".all with conditions" do
    before do
      create_3_sources
      @sources = Source.all(:title => "NASA Data")
    end

    it "should return an enumeration of sources" do
      @sources.each do |source|
        source.should be_an_instance_of(Source)
      end
    end

    it "should return correct titles" do
      expected = ["NASA Data"]
      @sources.map(&:title).sort.should == expected.sort
    end
  end

  describe ".create" do
    it "should create a new source from basic params" do
      source = create_source
      source.should be_an_instance_of(Source)
      source.url.should == "http://fcc.gov/somedata.csv"
    end

    it "should create a new source from custom params" do
      source = create_source({ :custom => {
        "0" => {
          :label       => "License",
          :description => "License",
          :type        => "string",
          :value       => "Public Domain"
        }
      }})
      source.should be_an_instance_of(Source)
      source.url.should == "http://fcc.gov/somedata.csv"
      source.custom.should == {
        "0" => {
          "label"       => "License",
          "description" => "License",
          "type"        => "string",
          "value"       => "Public Domain"
        }
      }
    end
  end

  describe ".destroy" do
    before do
      @source = create_source
    end

    it "should destroy an existing source" do
      result = Source.destroy(@source.id)
      result.should be_true
    end

    it "should raise NotFound when attempting to destroy non-existing source" do
      executing do
        Source.destroy(mangle(@source.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".first" do
    before do
      create_3_sources
    end

    it "should return a source" do
      source = Source.first(:title => "NASA Data")
      source.should be_an_instance_of(Source)
      source.title.should == "NASA Data"
    end

    it "should return nil if nothing found" do
      source = Source.first(:title => "UFO Data")
      source.should be_nil
    end
  end

  describe ".get" do
    before do
      @source = create_source
    end

    it "should return a source" do
      source = Source.get(@source.id)
      source.should be_an_instance_of(Source)
      source.title.should == "Some FCC Data"
    end

    it "should raise NotFound if no source exists" do
      executing do
        Source.get(mangle(@source.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".search" do
    before do
      create_3_sources
    end

    it "should return correct search result" do
      @sources = Source.search("FCC")
      @sources.size.should == 1
      @sources.first.title.should == "FCC Data"
    end
  end

  describe ".update" do
    before do
      @source = create_source
    end

    it "should update an existing source from valid params" do
      source = Source.update(@source.id, {
        :url => "http://fec.gov/newdata.csv"
      })
      source.should be_an_instance_of(Source)
      source.url.should == "http://fec.gov/newdata.csv"
    end
  end

end
