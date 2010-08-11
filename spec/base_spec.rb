require File.dirname(__FILE__) + '/spec_helper'
include DataCatalog

describe Base do

  def make_response(body, code)
    response = Object.new
    stub(response).code { code }
    stub(response).body { body }
    response
  end

  before do
    setup_api
  end

  describe ".base_uri=" do
    it "should set and normalize the base URI" do
      setup_api
      DataCatalog.base_uri = 'host.com'
      DataCatalog.base_uri.should == 'http://host.com'
    end

    it "should set the base URI to the default if it's not explicitly defined" do
      DataCatalog.base_uri = ''
      DataCatalog.base_uri.should == 'http://api.nationaldatacatalog.com'
      DataCatalog.base_uri.should == 'http://api.nationaldatacatalog.com'
    end
  end

  describe ".check_status" do
    it "should return response on 200 OK" do
      response = make_response("{}", 200)
      Base.check_status(response).should == response
    end

    it "should raise BadRequest on 400 Bad Request" do
      executing do
        Base.check_status(make_response("{}", 400))
      end.should raise_error(BadRequest)
    end

    it "should raise Unauthorized on 401 Unauthorized" do
      executing do
        Base.check_status(make_response("{}", 401))
      end.should raise_error(Unauthorized)
    end

    it "should raise NotFound on 404 Not Found" do
      executing do
        Base.check_status(make_response("{}", 404))
      end.should raise_error(NotFound)
    end

    it "should raise InternalServerError on 500 Internal Server Error" do
      executing do
        Base.check_status(make_response("{}", 500))
      end.should raise_error(InternalServerError)
    end
  end
  
  describe ".error" do
    it "should be correct when body is blank and code is 404" do
      response = make_response('', 404)
      begin
        e = Base.error(NotFound, response)
      rescue NotFound => e
        e.response_body.should == ''
        e.parsed_response_body.should == nil
        e.errors.should == nil
      end
    end

    it "should be correct when body is an empty hash" do
      response = make_response('{}', 404)
      begin
        e = Base.error(NotFound, response).should == "Response was empty"
      rescue NotFound => e
        e.response_body.should == '{}'
        e.parsed_response_body.should == {}
        e.errors.should == nil
      end
    end

    it "should be correct when body is an empty array" do
      response = make_response('[]', 404)
      begin
        e = Base.error(NotFound, response)
      rescue NotFound => e
        e.response_body.should == '[]'
        e.parsed_response_body.should == []
        e.errors.should == nil
      end
    end

    it "should be correct when body has errors hash" do
      response = make_response('{"errors":["bad_error"]}', 400)
      begin
        e = Base.error(BadRequest, response)
      rescue BadRequest => e
        e.response_body.should == '{"errors":["bad_error"]}'
        e.parsed_response_body.should == {"errors" => ["bad_error"]}
        e.errors.should == ["bad_error"]
      end
    end

    it "should be correct when body has hash" do
      response = make_response('{"foo":["bar"]}', 400)
      begin
        e = Base.error(BadRequest, response)
      rescue BadRequest => e
        e.response_body.should == '{"foo":["bar"]}'
        e.parsed_response_body.should == {"foo" => ["bar"]}
        e.errors.should == nil
      end
    end
  end

  describe ".one" do
    it "should create an object from a filled hash" do
      hash = Base.one({
        :name  => "John Smith",
        :email => "john@email.com"
      })
      hash.should be_an_instance_of(Base)
      hash.name.should == "John Smith"
      hash.email.should == "john@email.com"
    end

    it "should return nil from an empty hash" do
      hash = Base.one({})
      hash.should be_nil
    end

    it "should return nil from nil" do
      hash = Base.one(nil)
      hash.should be_nil
    end
  end

  describe ".filterize" do
    it "should work with 1 integer param" do
      Base.filterize(:count => 7).should == %(count=7)
    end

    it "should work with 1 string param" do
      Base.filterize(:name => "John Doe").should == %(name="John Doe")
    end

    it "should work with 1 regex param" do
      Base.filterize(:name => /John Doe/).should == %(name:"John Doe")
    end

    it "should work with 2 string params" do
      [
        %(zip="20036" and name="John Doe"),
        %(name="John Doe" and zip="20036")
      ].should include(Base.filterize(:name => "John Doe", :zip => "20036"))
    end

    it "should work with periods" do
      Base.filterize('released.year' => 2008).should == %(released.year=2008)
    end

    it "should support 'or' by converting arrays to commas" do
      Base.filterize('id' => [800, 801, 802]).should == %(id=800,801,802)
    end

    it "should pass through strings" do
      ["count > 0", "count >= 1"].each do |s|
        Base.filterize(s).should == s
      end
    end

    it "should work with boolean true" do
      Base.filterize('is_awesome' => true).should == %(is_awesome=true)
    end

    it "should work with boolean false" do
      Base.filterize('is_suck' => false).should == %(is_suck=false)
    end

    it "should raise ArgumentError when appropriate" do
      [nil, [1]].each do |arg|
        executing { Base.filterize(arg) }.should raise_error(ArgumentError)
      end
    end
  end

end
