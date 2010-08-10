require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Rating do

  before do
    setup_api
    clean_slate
    @user = User.create(
      :name  => "Ted Smith",
      :email => "ted@email.com"
    )
    @user2 = User.create(
      :name  => "Chad Johnson",
      :email => "chad@email.com"
    )
    @source = Source.create(
      :title       => "Some FCC Data",
      :url         => "http://fcc.gov/somedata.csv",
      :source_type => "dataset"
    )
    DataCatalog.with_key(@user.primary_api_key) do
      @comment = Comment.create(
        :source_id => @source.id,
        :text      => "This is a useful comment."
      )
    end
  end

  describe ".all" do
    before do
      DataCatalog.with_key(@user.primary_api_key) do
        @rating = Rating.create(:kind => "source", :source_id => @source.id, :value => 5)
      end

      DataCatalog.with_key(@user2.primary_api_key) do
        @rating = Rating.create(:kind => "source", :source_id => @source.id, :value => 3)
      end
    end

    it "should return a collection of all the source's ratings" do
      ratings = Rating.all(:source_id => @source.id)

      ratings[0].should be_an_instance_of(Rating)
      ratings[0].value.should == 5
      ratings[1].value.should == 3
    end
  end

  describe ".create" do
    it "should create a source rating when valid params are passed in" do
      DataCatalog.with_key(@user.primary_api_key) do
        @rating = Rating.create(:kind => "source", :source_id => @source.id, :value => 5)
      end

      refreshed_source = Source.get(@source.id)
      refreshed_source.rating_stats.average.should == 5
      refreshed_source.rating_stats.total.should == 5
    end

    it "should create a comment rating when valid params are passed in" do
      DataCatalog.with_key(@user2.primary_api_key) do
        @rating = Rating.create(:kind => "comment", :comment_id => @comment.id, :value => 1)
      end

      refreshed_comment = Comment.get(@comment.id)
      refreshed_comment.rating_stats.average.should == 1
      refreshed_comment.rating_stats.total.should == 1
    end
  end

  describe ".destroy" do
    before do
      DataCatalog.with_key(@user.primary_api_key) do
        @rating = Rating.create(:kind => "source", :source_id => @source.id, :value => 5)
      end
    end

    it "should destroy an existing rating as an admin" do
      Rating.destroy(@rating.id).should be_true
    end

    it "should destroy an existing rating as the user" do
      DataCatalog.with_key(@user.primary_api_key) do
        Rating.destroy(@rating.id).should be_true
      end
    end

    it "should raise NotFound when attempting to destroy non-existing rating" do
      executing do
        Rating.destroy(mangle(@rating.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".get" do
    before do
      DataCatalog.with_key(@user.primary_api_key) do
        @rating = Rating.create(:kind => "source", :source_id => @source.id, :value => 5)
      end
    end

    it "should return a rating" do
      rating = Rating.get(@rating.id)
      rating.should be_an_instance_of(Rating)
      rating.value.should == 5
    end

    it "should raise NotFound if no rating exists" do
      executing do
        Rating.get(mangle(@rating.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".update" do
    before do
      DataCatalog.with_key(@user.primary_api_key) do
        @rating = Rating.create(:kind => "source", :source_id => @source.id, :value => 5)
      end
    end

    it "should update an existing rating with valid params" do
      DataCatalog.with_key(@user.primary_api_key) do
        Rating.update(@rating.id, :value => 3)
      end

      refreshed_rating = Rating.get(@rating.id)
      refreshed_rating.value.should == 3
      refreshed_rating.previous_value.should == 5
    end
  end
end
