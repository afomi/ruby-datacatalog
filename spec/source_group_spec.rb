require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

module SourceGroupHelpers
  def create_source_group(params={})
    valid_params = {
      :title => "FCC Data",
    }
    SourceGroup.create(valid_params.merge(params))
  end

  def create_3_source_groups
    %w(FCC NASA DOE).each do |name|
      SourceGroup.create({
        :title => "#{name} Data",
      })
    end
  end
  
  def create_30_source_groups
    (1..30).each do |n|
      SourceGroup.create({
        :title => "Dataset #{n.to_s}",
      })
    end
  end
end

describe SourceGroup do
  include SourceGroupHelpers

  before do
    setup_api
    clean_slate
  end

  describe ".all" do
    before do
      create_3_source_groups
      @source_groups = SourceGroup.all
    end
    
    it "should return an Enumerable object" do
      @source_groups.is_a?(Enumerable).should == true
    end
  
    it "should return an enumeration of sources" do
      @source_groups.each do |source_group|
        source_group.should be_an_instance_of(SourceGroup)
      end
    end
    
    it "should return correct titles" do
      expected = ["FCC Data", "NASA Data", "DOE Data"]
      @source_groups.map(&:title).sort.should == expected.sort
    end
    
    describe "with cursor" do
      it "should raise an error on bad index" do
        executing do
          @source_groups.page(0)
        end.should raise_error(RuntimeError)
      end
    
      it "should return 20 objects when there are more than 20" do
        create_30_source_groups
        source_groups = SourceGroup.all
        source_groups.size.should == 20
        source_groups.page(1).size.should == 20
        source_groups.page(2).size.should == 13
      end
    end
  end
  
  describe ".all with conditions" do
    before do
      create_3_source_groups
      @source_groups = SourceGroup.all(:title => "NASA Data")
    end
    
    it "should return an enumeration of sources" do
      @source_groups.each do |source|
        source.should be_an_instance_of(SourceGroup)
      end
    end
    
    it "should return correct titles" do
      expected = ["NASA Data"]
      @source_groups.map(&:title).sort.should == expected.sort
    end
  end
  
  describe ".search" do
    before do
      create_3_source_groups
    end
    
    it "should return correct search result" do
      @source_groups = SourceGroup.search("FCC")
      @source_groups.size.should == 1
      @source_groups.first.title.should == "FCC Data"
    end
  end
  
  describe ".create" do
    it "should create a new source group from basic params" do
      source_group = create_source_group
      source_group.should be_an_instance_of(SourceGroup)
      source_group.title.should == "FCC Data"
    end
  end

  describe ".first" do
    before do
      create_3_source_groups
    end
  
    it "should return a source" do
      source_group = SourceGroup.first(:title => "NASA Data")
      source_group.should be_an_instance_of(SourceGroup)
      source_group.title.should == "NASA Data"
    end
    
    it "should return nil if nothing found" do
      source_group = SourceGroup.first(:title => "UFO Data")
      source_group.should be_nil
    end
  end
  
  describe ".get" do
    before do
      @source_group = create_source_group
    end
  
    it "should return a source" do
      source_group = SourceGroup.get(@source_group.id)
      source_group.should be_an_instance_of(SourceGroup)
      source_group.title.should == "FCC Data"
    end
    
    it "should raise NotFound if no source group exists" do
      executing do
        SourceGroup.get(mangle(@source_group.id))
      end.should raise_error(NotFound)
    end
  end
  
  describe ".update" do
    before do
      @source_group = create_source_group
    end
  
    it "should update an existing source group from valid params" do
      source_group = SourceGroup.update(@source_group.id, {
        :title => "Important FCC Data"
      })
      source_group.should be_an_instance_of(SourceGroup)
      source_group.title.should == "Important FCC Data"
    end
  end
  
  describe ".destroy" do
    before do
      @source_group = create_source_group
    end
  
    it "should destroy an existing source" do
      result = SourceGroup.destroy(@source_group.id)
      result.should be_true
    end
    
    it "should raise NotFound when attempting to destroy non-existing source" do
      executing do
        SourceGroup.destroy(mangle(@source_group.id))
      end.should raise_error(NotFound)
    end
  end

end
