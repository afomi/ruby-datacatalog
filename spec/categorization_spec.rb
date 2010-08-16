require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Categorization do

  before do
    setup_api
    clean_slate
    @sources = [
      Source.create(
        :title       => "Some FCC Data",
        :url         => "http://fcc.gov/somedata.csv",
        :source_type => "dataset"
      ),
      Source.create(
        :title       => "Some Other Local Data",
        :url         => "http://local.gov/currentdata.xml",
        :source_type => "dataset"
      )
    ]
    @categories = [
      Category.create(:name => "Category-0"),
      Category.create(:name => "Category-1")
    ]
    @categorizations = [
      Categorization.create(:source_id => @sources[0].id, :category_id => @categories[0].id),
      Categorization.create(:source_id => @sources[0].id, :category_id => @categories[1].id),
      Categorization.create(:source_id => @sources[1].id, :category_id => @categories[0].id),
    ]
  end

  describe ".create" do
    it "should create a new categorization when valid params are passed in" do
      @categorizations[0].should be_an_instance_of(Categorization)
    end
  end

  describe ".get" do
    it "should return a categorization" do
      categorization = Categorization.get(@categorizations[0].id)
      categorization.should be_an_instance_of(Categorization)
    end

    it "should raise NotFound if no categorization exists" do
      executing do
        Categorization.get(mangle(@categorizations[0].id))
      end.should raise_error(NotFound)
    end
  end

  describe ".all" do
    it "should return a set of all categorizations" do
      categorizations = Categorization.all
      categorizations.each do |categorization|
        categorization.should be_an_instance_of(Categorization)
      end
      ids = categorizations.map do |categorization|
        categorization.id.to_s
      end
      ids.uniq.length.should == 3
    end
  end

  describe ".update" do
    it "should update an existing categorization as admin" do
      Categorization.update(@categorizations[0].id, :category_id => @categories[1].id)

      refreshed_Categorization = Categorization.get(@categorizations[0].id)
      refreshed_Categorization.category_id.should == @categories[1].id
    end

  end

  describe ".destroy" do 
    it "should destroy an existing categorization" do
      Categorization.destroy(@categorizations[0].id).should be_true
    end

    it "should raise NotFound when attempting to destroy non-existing categorization" do
      executing do
        Categorization.destroy(mangle(@categorizations[0].id))
      end.should raise_error(NotFound)
    end
  end
end

