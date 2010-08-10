require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Download do

  before do
    setup_api
    clean_slate
    @user = User.create(
      :name  => "Ted Smith",
      :email => "ted@email.com"
    )
    @source = Source.create(
      :title       => "Some FCC Data",
      :url         => "http://fcc.gov/somedata.csv",
      :source_type => "dataset"
    )
    @download = Download.create(
      :source_id  => @source.id,
      :format     => "CSV",
      :url        => "http://somedata.gov/test.csv",
      :preview    => "1,2,3,4,5"
    )
  end

  describe ".create" do
    it "should create a download when valid params are passed in" do
      refreshed_source = Source.get(@source.id)
      refreshed_source.downloads.first.url.should == "http://somedata.gov/test.csv"
    end
  end

  describe ".get" do
    it "should return a download" do
      download = Download.get(@download.id)
      download.should be_an_instance_of(Download)
      download.source_id.should == @source.id
    end

    it "should raise NotFound if no download exists" do
      executing do
        Download.get(mangle(@download.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".all" do
    it "should return an enumeration of downloads" do
      downloads = Download.all(:source_id => @source.id)
      downloads.each do |o|
        o.should be_an_instance_of(Download)
      end
    end
  end

  describe ".update" do
    it "should update an existing download with valid params" do
      Download.update(@download.id, :preview => "10,11,12,13")
      refreshed_download = Download.get(@download.id)
      refreshed_download.preview.should == "10,11,12,13"
    end
  end

  describe ".destroy" do
    it "should destroy an existing download as an admin" do
      Download.destroy(@download.id).should be_true
    end

    it "should raise NotFound when attempting to destroy non-existing download" do
      executing do
        Download.destroy(mangle(@download.id))
      end.should raise_error(NotFound)
    end
  end

end
