require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe "Test Emptiness" do

  before do
    setup_api
    clean_slate
  end
  
  def expect_none_of(klass)
    klass.all.should be_empty
  end
  
  describe ".all" do
    it "no comments" do
      expect_none_of Comment
    end
    
    it "no documents" do
      expect_none_of Document
    end

    it "no downloads" do
      expect_none_of Download
    end
    
    it "no favorites" do
      expect_none_of Favorite
    end

    it "no imports" do
      expect_none_of Import
    end

    it "no importers" do
      expect_none_of Importer
    end

    it "no notes" do
      expect_none_of Note
    end

    it "no organizations" do
      expect_none_of Organization
    end

    it "no ratings" do
      expect_none_of Rating
    end

    it "no reports" do
      expect_none_of Report
    end

    it "no sources" do
      expect_none_of Source
    end
  end

end
