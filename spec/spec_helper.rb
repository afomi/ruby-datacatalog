require File.dirname(__FILE__) + '/../lib/datacatalog'

Spec::Runner.configure do |config|
  config.mock_with :rr
end

alias :executing :lambda

def setup_api
  DataCatalog.api_key = 'flurfeneugen'
  DataCatalog.base_uri = 'somehost.com'
end

# The hashes (and arrays of hashes) we would get back from httparty
def mock_response_for(method, resource, code=200, body='', headers={}, message='')
  
  method = method.to_sym
  
  case resource
  
  when '/'
    
    case method 
    when :get
      HTTParty::Response.new({"name"=>"National Data Catalog API", "creator"=>"The Sunlight Labs", 
                              "resources"=>{"/"=>"http://dc-api.local/", "checkup"=>"http://dc-api.local/checkup"},
                              "version"=>"0.10"}, body, code, message, headers) 
    end
    
  when '/users'
    
    case method
    when :get
      HTTParty::Response.new([{"creator_api_key"=>nil, "name"=>"National Data Catalog", "purpose"=>nil,
                               "updated_at"=>"2009/08/17 16:07:17 +0000", "admin"=>true, "id"=>"792890124a89803500000008",
                               "primary_api_key"=>"6bc4fd27816d05b2e39886a9e6c5472b8264c8de", "secondary_api_keys"=>[], 
                               "email"=>"ndc@sunlightlabs.com", "created_at"=>"2009/08/17 16:07:17 +0000"}], body, code, message, headers)
    when :post
      HTTParty::Response.new({"creator_api_key"=>nil, "name"=>"National Data Catalog", "purpose"=>"To be awesome.", 
                              "updated_at"=>"2009/08/17 16:07:17 +0000", "admin"=>true, "id"=>"792890124a89803500000008",
                              "primary_api_key"=>"6bc4fd27816d05b2e39886a9e6c5472b8264c8de", "secondary_api_keys"=>[],
                              "email"=>"ndc@sunlightlabs.com", "created_at"=>"2009/08/17 16:07:17 +0000"}, body, code, message, headers)
    end
        
  when '/users/someid'

    case method
    when :get
       HTTParty::Response.new({"creator_api_key"=>nil, "name"=>"National Data Catalog", "purpose"=>nil, 
                               "updated_at"=>"2009/08/17 16:07:17 +0000", "admin"=>true, "id"=>"792890124a89803500000008",
                               "primary_api_key"=>"6bc4fd27816d05b2e39886a9e6c5472b8264c8de", "secondary_api_keys"=>[],
                               "email"=>"ndc@sunlightlabs.com", "created_at"=>"2009/08/17 16:07:17 +0000"}, body, code, message, headers)
    end

  when '/users/badid'

    case method
    when :get
      HTTParty::Response.new([], body, code, message, headers)
    end

  end 
end