require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Note do
  
  before do
    setup_api
    clean_slate
    
    @user = User.create(:name  => "Ted Smith",
                        :email => "ted@email.com")
    
    @source = Source.create(:title       => "Some FCC Data",
                            :url         => "http://fcc.gov/somedata.csv",
                            :source_type => "dataset")
    
    DataCatalog.with_key(@user.primary_api_key) do
      @note = Note.create(:source_id => @source.id, :text => "This is my note.")
    end
    
  end
  
  describe ".create" do

    it "should create a note when valid params are passed in" do
      DataCatalog.with_key(@user.primary_api_key) do
        refreshed_source = Source.get(@source.id)
        refreshed_source.notes.first.text.should == "This is my note."
      end
    end
    
  end # describe ".create"
  
  describe ".get" do
  
    it "should return a note" do
      note = Note.get(@note.id)
      note.should be_an_instance_of(Note)
      note.user_id.should == @user.id
    end
    
    it "should raise NotFound if no note exists" do
      executing do
        Note.get(mangle(@note.id))
      end.should raise_error(NotFound)
    end
    
  end # describe ".get"
  
  describe ".all" do
  
    it "should return a collection of all the user's notes" do
      notes = Note.all(:user_id => @user.id)
  
      notes.should be_an_instance_of(Array)
      notes[0].should be_an_instance_of(Note)
    end
    
  end # describe ".all"
  
  describe ".update" do

    it "should update an existing note with valid params" do
      DataCatalog.with_key(@user.primary_api_key) do
        Note.update(@note.id, :text => "This is my updated note.")
      end
      
      refreshed_note = Note.get(@note.id)
      refreshed_note.text.should == "This is my updated note."
    end
    
  end # describe ".update"

  describe ".destroy" do

    it "should destroy an existing note as an admin" do
      Note.destroy(@note.id).should be_true
    end
    
    it "should destroy an existing note as the user" do
      DataCatalog.with_key(@user.primary_api_key) do
        Note.destroy(@note.id).should be_true
      end
    end
    
    it "should raise NotFound when attempting to destroy non-existing note" do
      executing do
        Note.destroy(mangle(@note.id))
      end.should raise_error(NotFound)
    end
    
  end # describe ".destroy"
  
end