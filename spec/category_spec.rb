require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Category do
  
  before do
    setup_api
    clean_slate
    @user = User.create(
      :name    => "Ted Smith",
      :email   => "ted@email.com",
      :curator => true)

    DataCatalog.with_key(@user.primary_api_key) do
      @category  = Category.create(:name => "TestCategory1")
      @category2 = Category.create(:name => "TestCategory2")
    end
  end
  
  describe ".create" do
    it "should create a new category when valid params are passed in" do
      @category.should be_an_instance_of(Category)
      @category.name.should == "TestCategory1"
    end
  end

  describe ".get" do
    it "should return a category" do
      category = Category.get(@category.id)
      category.should be_an_instance_of(Category)
      category.name.should == "TestCategory1"
    end
    
    it "should raise NotFound if no category exists" do
      executing do
        Category.get(mangle(@category.id))
      end.should raise_error(NotFound)
    end
  end

  describe ".all" do
    it "should return a set of all categories" do
      categories = Category.all
      categories.first.should be_an_instance_of(Category)
      [1, 2].each_with_index do |nth, i|
        categories[i].name.should == "TestCategory#{nth}"
      end
    end
  end

  describe ".update" do
    it "should update an existing category with valid params" do
      DataCatalog.with_key(@user.primary_api_key) do
        Category.update(@category.id, :name => "TestCategoryUpdate")
      end
      
      refreshed_category = Category.get(@category.id)
      refreshed_category.name.should == "TestCategoryUpdate"
    end
  end

  describe ".destroy" do 
    it "should destroy an existing category as an admin" do
      Category.destroy(@category.id).should be_true
    end
    
#    it "should not destroy an existing category as the user" do
#      DataCatalog.with_key(@user.primary_api_key) do
#        Category.destroy(@category.id).should be_false
#      end
#    end
    
    it "should raise NotFound when attempting to destroy non-existing category" do
      executing do
        Category.destroy(mangle(@category.id))
      end.should raise_error(NotFound)
    end
  end

end
