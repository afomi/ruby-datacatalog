require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Import do
  
  before do
    setup_api
    clean_slate
    @user = User.create(
      :name  => "Ted Smith",
      :email => "ted@email.com"
    )
    @importer = Importer.create(
      :name => "National Data Registry of Bats")
    timestamp = Time.now
    @imports = [
      Import.create({
        :importer_id => @importer.id,
        :status      => 'success',
        :started_at  => timestamp - 3645,
        :finished_at => timestamp - 3600,
      }),
      Import.create({
        :importer_id => @importer.id,
        :status      => 'success',
        :started_at  => timestamp - 45,
        :finished_at => timestamp,
      }),
    ]
  end

  describe ".get" do
    it "should return an import as a basic user" do
      import = DataCatalog.with_key(@user.primary_api_key) do
        Import.get(@imports[0].id)
      end
      import.should be_an_instance_of(Import)
      import.id.should == @imports[0].id
    end

    it "should raise NotFound if no import exists" do
      executing do
        Import.get(mangle(@imports[0].id))
      end.should raise_error(NotFound)
    end
  end

  describe ".create" do
    # (successful create is exercised in before block)

    it "a basic user should be unauthorized" do
      executing do
        DataCatalog.with_key(@user.primary_api_key) do
          Import.create(:name => "Idaho Data Catalog")
        end
      end.should raise_error(Unauthorized)
    end

    it "should fail with invalid params" do
      executing do
        Import.create(:cave => "The Batcave")
      end.should raise_error(BadRequest)
    end

    it "should fail when missing params" do
      executing do
        Import.create()
      end.should raise_error(BadRequest)
    end
  end
  
  describe ".all" do
    it "should return an enumeration of 2 imports" do
      imports = Import.all
      imports.length.should == 2
      imports.each do |o|
        o.should be_an_instance_of(Import)
      end
    end
  end

  describe ".update" do
    it "a basic user should be unauthorized" do
      executing do
        DataCatalog.with_key(@user.primary_api_key) do
          Import.update(@imports[0].id, :status => 'failure')
        end
      end.should raise_error(Unauthorized)
    end

    it "should update an existing import with valid params" do
      @imports[0].status.should == 'success'
      Import.update(@imports[0].id, :status => 'failure')
      import = Import.get(@imports[0].id)
      import.status.should == 'failure'
    end
  end

  describe ".destroy" do
    it "should destroy an existing import as an admin" do
      Import.destroy(@imports[0].id).should be_true
    end
    
    it "should not destroy an existing import as a basic user" do
      DataCatalog.with_key(@user.primary_api_key) do
        executing do
          Import.destroy(@imports[0].id)
        end.should raise_error(Unauthorized)
      end
    end
    
    it "should raise NotFound when attempting to destroy non-existing import" do
      executing do
        Import.destroy(mangle(@imports[0].id))
      end.should raise_error(NotFound)
    end
  end
  
end
