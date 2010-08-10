require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Comment do

  before do
    setup_api
    clean_slate
    @user = User.create(
      :name  => "Ted Smith",
      :email => "ted@email.com")
    @source = Source.create(
      :title       => "Some FCC Data",
      :url         => "http://fcc.gov/somedata.csv",
      :source_type => "dataset")
  end

  describe ".all" do
    before do
      @john = User.create(
        :name  => "John Smith",
        :email => "john@email.com")
      @data = Source.create(
        :title       => "Some FEC Data",
        :url         => "http://fec.gov/somedata.csv",
        :source_type => "dataset")
      DataCatalog.with_key(@john.primary_api_key) do
        Comment.create(:source_id => @data.id, :text => "The first comment.")
        Comment.create(:source_id => @data.id, :text => "The second comment.")
      end
    end

    it "should return a set of all user's comments" do
      comments = Comment.all(:user_id => @john.id)
      comments.first.should be_an_instance_of(Comment)
      ["first", "second"].each_with_index do |nth, i|
        comments[i].text.should == "The #{nth} comment."
      end
    end
  end

  describe ".create" do
    it "should create a new comment when valid params are passed in" do
      DataCatalog.with_key(@user.primary_api_key) do
        @comment = Comment.create(:source_id => @source.id, :text => "The first comment.")
      end
      @comment.should be_an_instance_of(Comment)

      refreshed_source = Source.get(@source.id)
      refreshed_source.comments.first.text.should == "The first comment."
      refreshed_source.comments.first.user.name.should == "Ted Smith"
    end
  end

  describe ".destroy" do
    before do
      DataCatalog.with_key(@user.primary_api_key) do
        @comment = Comment.create(:source_id => @source.id, :text => "The first comment.")
      end
    end

    it "should destroy an existing comment as an admin" do
      Comment.destroy(@comment.id).should be_true
    end

    it "should destroy an existing comment as the user" do
      DataCatalog.with_key(@user.primary_api_key) do
        Comment.destroy(@comment.id).should be_true
      end
    end

    it "should raise NotFound when attempting to destroy non-existing comment" do
      executing do
        Comment.destroy(mangle(@comment.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".get" do
    before do
      DataCatalog.with_key(@user.primary_api_key) do
        @comment = Comment.create(:source_id => @source.id, :text => "The first comment.")
      end
    end

    it "should return a comment" do
      comment = Comment.get(@comment.id)
      comment.should be_an_instance_of(Comment)
      comment.text.should == "The first comment."
    end

    it "should raise NotFound if no comment exists" do
      executing do
        Comment.get(mangle(@comment.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".update" do
    before do
      DataCatalog.with_key(@user.primary_api_key) do
        @comment = Comment.create(:source_id => @source.id, :text => "The first comment.")
      end
    end

    it "should update an existing comment with valid params" do
      DataCatalog.with_key(@user.primary_api_key) do
        Comment.update(@comment.id, :text => "The first comment, updated.")
      end

      refreshed_source = Source.get(@source.id)
      refreshed_source.comments.first.text.should == "The first comment, updated."
      refreshed_source.comments.first.user.name.should == "Ted Smith"
    end
  end

end
