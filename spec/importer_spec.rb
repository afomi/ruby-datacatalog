require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Importer do

  before do
    setup_api
    clean_slate
    @user = User.create(
      :name  => "Ted Smith",
      :email => "ted@email.com"
    )
    @importers = [
      Importer.create(:name => "National Data Registry of Bats"),
      Importer.create(:name => "Bat-Inspired Superheroes"),
    ]
  end

  describe ".get" do
    it "should return an importer as a basic user" do
      importer = DataCatalog.with_key(@user.primary_api_key) do
        Importer.get(@importers[0].id)
      end
      importer.should be_an_instance_of(Importer)
      importer.id.should == @importers[0].id
    end

    it "should raise NotFound if no importer exists" do
      executing do
        Importer.get(mangle(@importers[0].id))
      end.should raise_error(NotFound)
    end
  end

  describe ".create" do
    # (successful create is exercised in before block)

    it "a basic user should be unauthorized" do
      executing do
        DataCatalog.with_key(@user.primary_api_key) do
          Importer.create(:name => "Idaho Data Catalog")
        end
      end.should raise_error(Unauthorized)
    end

    it "should fail with invalid params" do
      executing do
        Importer.create(:cave => "The Batcave")
      end.should raise_error(BadRequest)
    end

    it "should fail when missing params" do
      executing do
        Importer.create()
      end.should raise_error(BadRequest)
    end
  end

  describe ".all" do
    it "should return an enumeration of 2 importers" do
      importers = Importer.all
      importers.length.should == 2
      importers.each do |o|
        o.should be_an_instance_of(Importer)
      end
    end
  end

  describe ".update" do
    it "a basic user should be unauthorized" do
      executing do
        DataCatalog.with_key(@user.primary_api_key) do
          Importer.update(@importers[0].id, :name => "International Bat Registry")
        end
      end.should raise_error(Unauthorized)
    end

    it "should update an existing importer with valid params" do
      @importers[0].name.should == "National Data Registry of Bats"
      Importer.update(@importers[0].id, :name => "International Bat Registry")
      importer = Importer.get(@importers[0].id)
      importer.name.should == "International Bat Registry"
    end
  end

  describe ".destroy" do
    it "should destroy an existing importer as an admin" do
      Importer.destroy(@importers[0].id).should be_true
    end

    it "should not destroy an existing importer as a basic user" do
      DataCatalog.with_key(@user.primary_api_key) do
        executing do
          Importer.destroy(@importers[0].id)
        end.should raise_error(Unauthorized)
      end
    end

    it "should raise NotFound when attempting to destroy non-existing importer" do
      executing do
        Importer.destroy(mangle(@importers[0].id))
      end.should raise_error(NotFound)
    end
  end

end
