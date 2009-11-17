require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Document do
  
  before do
    setup_api
    clean_slate
    
    @user = User.create(:name  => "Ted Smith",
                        :email => "ted@email.com")
    
    @source = Source.create(:title       => "Some FCC Data",
                            :url         => "http://fcc.gov/somedata.csv",
                            :source_type => "dataset")
    
    DataCatalog.with_key(@user.primary_api_key) do
      @document = Document.create(:source_id => @source.id, :text => "This is community documentation.")
    end
    
  end
  
  describe ".create" do

    it "should create a document when valid params are passed in" do
      DataCatalog.with_key(@user.primary_api_key) do
        refreshed_source = Source.get(@source.id)
        refreshed_source.documents.first.text.should == "This is community documentation."
      end
    end
    
  end # describe ".create"
  
  describe ".get" do
  
    it "should return a document" do
      document = Document.get(@document.id)
      document.should be_an_instance_of(Document)
      document.source_id.should == @source.id
    end
    
    it "should raise NotFound if no document exists" do
      executing do
        Document.get(mangle(@document.id))
      end.should raise_error(NotFound)
    end
    
  end # describe ".get"
  
  describe ".all" do
  
    it "should return a collection of all the source's documents" do
      documents = Document.all(:source_id => @source.id)
  
      documents.should be_an_instance_of(Array)
      documents[0].should be_an_instance_of(Document)
    end
    
  end # describe ".all"
  
  describe ".update" do
  
    it "should update an existing document with valid params" do
      @document.previous_id.should be nil
      DataCatalog.with_key(@user.primary_api_key) do
        Document.update(@document.id, :text => "This is the updated document.")
      end
      
      refreshed_document = Document.get(@document.id)
      refreshed_document.text.should == "This is the updated document."
      refreshed_document.previous_id.should_not be nil
    end
    
  end # describe ".update"

  describe ".destroy" do

    it "should destroy an existing document as an admin" do
      Document.destroy(@document.id).should be_true
    end
    
    it "should not destroy an existing document as the user" do
      DataCatalog.with_key(@user.primary_api_key) do
        executing { Document.destroy(@document.id) }.should raise_error(Unauthorized)
      end
    end
    
    it "should raise NotFound when attempting to destroy non-existing document" do
      executing do
        Document.destroy(mangle(@document.id))
      end.should raise_error(NotFound)
    end
    
  end # describe ".destroy"
  
end