require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe DataCatalog do

  describe "module accessors" do
    it "should access the API Key" do
      DataCatalog.api_key = "4159179f32ff8fefd2c6d48b7e675e7736bf1357"
      DataCatalog.api_key.should == "4159179f32ff8fefd2c6d48b7e675e7736bf1357"
    end

    it "should access the base URI" do
      DataCatalog.base_uri = 'http://somehost.com'
      DataCatalog.base_uri.should == 'http://somehost.com'
    end
  end

  describe ".with_key" do
    it "should set the API key within the block" do
      regular_key = '4159179f32ff8fefd2c6d48b7e675e7736bf1357'
      DataCatalog.api_key = regular_key
      temporary_key = '0000123400001234000012340000123400001234'
      DataCatalog.with_key(temporary_key) do
        DataCatalog.api_key.should == temporary_key
      end
      DataCatalog.api_key.should == regular_key
    end

    it "should return the last value in the block" do
      DataCatalog.with_key("0000444400004444") do
        42
      end.should == 42
    end

    it "should still reset the API key when the block throws an exception" do
      regular_key = '4159179f32ff8fefd2c6d48b7e675e7736bf1357'
      DataCatalog.api_key = regular_key
      temporary_key = '0000123400001234000012340000123400001234'
      expect {
        DataCatalog.with_key(temporary_key) do
          raise Exception
        end
      }.to raise_error(Exception)
      DataCatalog.api_key.should == regular_key 
    end
  end

end
