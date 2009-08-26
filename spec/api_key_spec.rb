require File.dirname(__FILE__) + '/spec_helper'

describe "" do

  before(:each) { setup_api }

  def setup_user_with_api_keys(n)
    user_id = "4b9630f54a8eb69c00000001"
    user = DataCatalog::User.new(:name => "John Doe", :id => user_id)
    @keys = (0...n).map do |i|
      key = DataCatalog::ApiKey.new
      key.api_key    = "#{i}fef14e0e81eb7c6b43e47b969f3a282ce0730e3"
      key.purpose    = "Civic hacking with my #{i}th awesome app"
      key.created_at = Time.now.to_s
      key
    end
    user.instance_variable_set(:@api_keys, @keys)
    user
  end

  it "generate_api_key should work" do
    user_id = "4b9630f54a8eb69c00000001"
    user = DataCatalog::User.new(:name => "John Doe", :id => user_id)
    valid_params = { :purpose => "Civic hacking with my awesome app" }
    mock(DataCatalog::User).post("/users/#{user_id}/api_keys", :query => valid_params) do 
      parsed_body = {
        :api_key    => "123456789",
        :purpose    => "Civic hacking with my awesome app",
        :created_at => Time.now.to_s
      }
      HTTParty::Response.new(parsed_body, parsed_body.to_json, 200, "OK", {})
    end
    
    user.generate_api_key("Civic hacking with my awesome app")
    user.api_keys.length.should eql(1)
    user.api_keys[0][:purpose].should eql("Civic hacking with my awesome app")
  end
  
  it "api_keys= should fail" do
    user_id = "4b9630f54a8eb69c00000001"
    user = DataCatalog::User.new(:name => "John Doe", :id => user_id)
    executing do
      user.api_keys = [:no_way]
    end.should raise_error(NoMethodError)
  end
  
  it "api_keys should return array of API keys" do
    user = setup_user_with_api_keys(3)
    api_keys = user.api_keys
    
    api_keys.should be_an_instance_of(Array)
    api_keys.length.should eql(3)
    
    api_keys.each_with_index do |api_key, i|
      api_key.should be_an_instance_of(DataCatalog::ApiKey)
      api_key.purpose.should eql("Civic hacking with my #{i}th awesome app")
    end
  end
  
  # it "secondary_api_keys should return all secondary API keys" do
  #   user = setup_user_with_api_keys(3)
  #   secondary_keys = user.secondary_api_keys
  #         
  #   secondary_keys.each_with_index do |api_key, i|
  #     api_key.should be_an_instance_of(DataCatalog::ApiKey)
  #     api_key.purpose.should eql("Civic hacking with my #{i + 1}th awesome app")
  #   end
  # end
  # 
  # it "secondary_api_keys should return an empty array if no secondary keys exist" do
  #   user = setup_user_with_api_keys(1)
  #   secondary_keys = user.secondary_api_keys
  #   secondary_keys.should be_empty
  # end
  
  
  it "#delete_api_key should delete the given API key" do
    n = 4
    user = setup_user_with_api_keys(n)
    key = @keys[n - 1]
    mock(DataCatalog::User).delete("/users/#{user.id}/api_keys/#{key.api_key}") do
      parsed_body = {
        :id         => "00400b9630f54a8eb69c0000",
        :api_key    => key.api_key,
        :purpose    => "Civic hacking with my awesome app",
        :created_at => Time.now.to_s
      }
      HTTParty::Response.new(parsed_body, parsed_body.to_json, 200, "OK", {})
    end
    
    result = user.delete_api_key(key.api_key)
    result.should be_true
    
    api_keys = user.api_keys
    api_keys.length.should eql(n - 1)

    api_keys.each_with_index do |api_key, i|
      api_key.should be_an_instance_of(DataCatalog::ApiKey)
      api_key.purpose.should eql("Civic hacking with my #{i}th awesome app")
    end
  end
  
  # it "#delete_api_key should not allow the deletion of a primary API key" do
  #   n = 4
  #   user = setup_user_with_api_keys(n)
  #   key = @keys[0]
  #   mock(DataCatalog::User).delete("/users/#{user.id}/api_keys/#{key.api_key}") do
  #     parsed_body = {
  #       :id         => "00400b9630f54a8eb69c0000",
  #       :api_key    => key.api_key,
  #       :purpose    => "Civic hacking with my awesome app",
  #       :created_at => Time.now.to_s
  #     }
  #     HTTParty::Response.new(parsed_body, parsed_body.to_json, 200, "OK", {})
  #   end
  #   
  #   executing { user.delete_api_key(key.api_key) }.should raise_error(CannotDeletePrimaryApiKey)
  # end
  
  it "#delete_api_key should raise ApiKeyDoesNotExist if there is no API key" do
    pending
  end

end
