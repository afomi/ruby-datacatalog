require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe BrokenLink do

  before do
    setup_api
    clean_slate
    @user = User.create(
      :name    => "Q. Rater",
      :email   => "q_rater@email.com",
      :curator => true
    )
    @source = Source.create(
      :title       => "Some FCC Data",
      :url         => "http://fcc.gov/somedata.csv",
      :source_type => "dataset"
    )
    DataCatalog.with_key(@user.primary_api_key) do
      @broken_link = BrokenLink.create({
        :source_id       => @source.id,
        :field           => "url",
        :destination_url => "http://broken.gov/abx834",
        :status          => 404,
      })
    end
  end
  
  describe ".all" do
    it "should return an enumeration of broken_links" do
      broken_links = BrokenLink.all(:user_id => @user.id)
      broken_links.each do |o|
        o.should be_an_instance_of(BrokenLink)
      end
    end
  end

  describe ".create" do
    # (successful create is exercised in before block)

    it "should fail with invalid params" do
      begin
        BrokenLink.create(:mad => "hatter")
      rescue BadRequest => e
        e.errors.should == { "invalid_params" => ["mad"] }
      end
    end

    it "should fail when missing params" do
      begin
        BrokenLink.create()
      rescue BadRequest => e
        e.errors.should == {
          "destination_url" => ["can't be empty"],
          "field"           => ["can't be empty"],
          "status"          => ["can't be empty"],
          "base"            => ["source_id or organization_id needed"]
        }
      end
    end
  end

  describe ".destroy" do
    it "should destroy an existing broken_link as an admin" do
      BrokenLink.destroy(@broken_link.id).should be_true
    end

    it "should destroy an existing broken_link as the user" do
      DataCatalog.with_key(@user.primary_api_key) do
        BrokenLink.destroy(@broken_link.id).should be_true
      end
    end

    it "should raise NotFound when attempting to destroy non-existing broken_link" do
      executing do
        BrokenLink.destroy(mangle(@broken_link.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".first" do
    it "should return the first BrokenLink" do
      BrokenLink.first.id.should == @broken_link.id
    end
  end

  describe ".get" do
    it "should return a broken_link" do
      broken_link = BrokenLink.get(@broken_link.id)
      broken_link.should be_an_instance_of(BrokenLink)
      broken_link.source_id.should == @source.id
    end

    it "should raise NotFound if no broken_link exists" do
      executing do
        BrokenLink.get(mangle(@broken_link.id))
      end.should raise_error(NotFound)
    end
  end

end
