require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Favorite do

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
    DataCatalog.with_key(@user.primary_api_key) do
      @favorite = Favorite.create(:source_id => @source.id)
    end
  end

  describe ".create" do
    it "should create a favorite when valid params are passed in" do
      refreshed_user = User.get(@user.id)
      refreshed_user.favorites.first.title.should == "Some FCC Data"
    end
  end

  describe ".first" do
    it "should return the first Favorite" do
      Favorite.first.id.should == @favorite.id
    end
  end

  describe ".get" do
    it "should return a favorite" do
      favorite = Favorite.get(@favorite.id)
      favorite.should be_an_instance_of(Favorite)
      favorite.user_id.should == @user.id
    end

    it "should raise NotFound if no favorite exists" do
      executing do
        Favorite.get(mangle(@favorite.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".all" do
    it "should return an enumeration of favorites" do
      favorites = Favorite.all(:user_id => @user.id)
      favorites.each do |o|
        o.should be_an_instance_of(Favorite)
      end
    end
  end

  describe ".destroy" do
    it "should destroy an existing favorite as an admin" do
      Favorite.destroy(@favorite.id).should be_true
    end

    it "should destroy an existing favorite as the user" do
      DataCatalog.with_key(@user.primary_api_key) do
        Favorite.destroy(@favorite.id).should be_true
      end
    end

    it "should raise NotFound when attempting to destroy non-existing favorite" do
      executing do
        Favorite.destroy(mangle(@favorite.id))
      end.should raise_error(NotFound)
    end
  end

end
