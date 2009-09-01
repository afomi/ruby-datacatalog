require File.dirname(__FILE__) + '/spec_helper'

describe DataCatalog::User do

  before(:each) { setup_api }

  def setup_user_with_api_keys(n)
    user_id = "someid"
    user = DataCatalog::User.new(:name => "John Doe", :id => user_id)
    @keys = (0...n).map do |i|
      key = DataCatalog::ApiKey.new
      key.api_key    = "#{i}fef14e0e81eb7c6b43e47b969f3a282ce0730e3"
      key.purpose    = "Civic hacking with my #{i}th awesome app"
      key.key_type   = (i == 0) ? "primary" : "application"
      key.created_at = Time.now.to_s
      key
    end
    user.api_keys = @keys
    user
  end

  it "#generate_api_key! should generate a new key for the user" do
    valid_user_params = {:name => "National Data Catalog", :email => "ndc@sunlightlabs.com"}
    mock(DataCatalog::User).post("/users", :query => valid_user_params) { mock_response_for(:post, '/users') }
    mock(DataCatalog::User).get("/users/someid/keys") { mock_response_for(:get, '/users/someid/keys') }
    
    user = DataCatalog::User.create(valid_user_params)  
    valid_params = { :purpose => "Civic hacking with my awesome app", :key_type => "application" }
    mock(DataCatalog::User).post("/users/#{user.id}/keys", :query => valid_params) do 
      parsed_body = {
        :api_key     => "123456789",
        :purpose     => "Civic hacking with my awesome app",
        :application => "application",
        :created_at  => Time.now.to_s
      }
      HTTParty::Response.new(parsed_body, parsed_body.to_json, 200, "OK", {})
    end
    
    mock(DataCatalog::User).get("/users/someid/keys") { mock_response_for(:get, '/users/someid2/keys') }
    
    user.generate_api_key!(valid_params).should be_true
    user.api_keys.length.should eql(2)
    user.api_keys[1][:purpose].should eql("Civic hacking with my awesome app")
  end
  
  # it "api_keys should return array of API keys" do
  #   user = setup_user_with_api_keys(3)
  #   api_keys = user.api_keys
  #   
  #   api_keys.should be_an_instance_of(Array)
  #   api_keys.length.should eql(3)
  #   
  #   api_keys.each_with_index do |api_key, i|
  #     api_key.should be_an_instance_of(DataCatalog::ApiKey)
  #     api_key.purpose.should eql("Civic hacking with my #{i}th awesome app")
  #   end
  # end
  
  # it "#delete_api_key should delete the given API key" do
  #   n = 4
  #   user = setup_user_with_api_keys(n)
  #   key = @keys[n - 1]
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
  #   result = user.delete_api_key(key.api_key)
  #   result.should be_true
  #   
  #   api_keys = user.api_keys
  #   api_keys.length.should eql(n - 1)
  # 
  #   api_keys.each_with_index do |api_key, i|
  #     api_key.should be_an_instance_of(DataCatalog::ApiKey)
  #     api_key.purpose.should eql("Civic hacking with my #{i}th awesome app")
  #   end
  # end
  
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
  
  # it "#delete_api_key should raise ApiKeyDoesNotExist if there is no API key" do
  #   pending
  # end

end
