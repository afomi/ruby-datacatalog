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
      HTTParty::Response.new(
        {
          "name"      => "National Data Catalog API",
          "creator"   => "The Sunlight Labs",
          "version"   => "0.10",
          "resources" =>  {
            "/"       => "http://dc-api.local/",
            "checkup" => "http://dc-api.local/checkup"
          },
        },
        body, code, message, headers
      )
    end
  when '/users'
    case method
    when :get
      HTTParty::Response.new(
        [
          {
            "admin"              => true,
            "created_at"         => "2009/08/17 16:07:17 +0000",
            "creator_api_key"    => nil,
            "email"              => "ndc@sunlightlabs.com",
            "id"                 => "792890124a89803500000008",
            "name"               => "National Data Catalog",
            "primary_api_key"    => "6bc4fd27816d05b2e39886a9e6c5472b8264c8de",
            "purpose"            => nil,
            "updated_at"         => "2009/08/17 16:07:17 +0000",
          }
        ],
        body, code, message, headers
      )
    when :post
      HTTParty::Response.new(
        {
          "admin"              => true,
          "created_at"         =>"2009/08/17 16:07:17 +0000",
          "creator_api_key"    => nil,
          "email"              =>"ndc@sunlightlabs.com",
          "id"                 => "someid",
          "name"               => "National Data Catalog",
          "primary_api_key"    => "6bc4fd27816d05b2e39886a9e6c5472b8264c8de",
          "purpose"            => "To be awesome.",
          "updated_at"         => "2009/08/17 16:07:17 +0000",
        },
        body, code, message, headers
      )
    end
  when '/users/someid'
    case method
    when :get
      HTTParty::Response.new(
        {
          "admin"              => true,
          "created_at"         => "2009/08/17 16:07:17 +0000",
          "creator_api_key"    => nil,
          "email"              => "ndc@sunlightlabs.com",
          "id"                 => "792890124a89803500000008",
          "name"               => "National Data Catalog",
          "primary_api_key"    => "6bc4fd27816d05b2e39886a9e6c5472b8264c8de",
          "purpose"            => nil,
          "updated_at"         => "2009/08/17 16:07:17 +0000",
        },
        body, code, message, headers
      )
    end
    
  when '/users/someid/keys'
    case method
      when :get
        HTTParty::Response.new(
        [
          { "purpose"    => nil, 
            "api_key"    => "79f2bbc9b58132539df9deef83df1132ab4dec53",
            "id"         => "9ed7d5c84a9c410e0000010a",
            "key_type"   => "primary",
            "created_at" => "2009/08/31 21:30:54 +0000" }
        ],
        body, code, message, headers)
      end

  when '/users/someid2/keys'
    case method
      when :get
        HTTParty::Response.new(
        [
          { "purpose"    => nil, 
            "api_key"    => "79f2bbc9b58132539df9deef83df1132ab4dec53",
            "id"         => "9ed7d5c84a9c410e0000010a",
            "key_type"   => "primary",
            "created_at" => "2009/08/31 21:30:54 +0000" },
          { "purpose"    => "Civic hacking with my awesome app", 
            "api_key"    => "79f2bbc9b58132539df9deef83df1132ab4dec55",
            "id"         => "9ed7d5c84a9c410e0000010a",
            "key_type"   => "application",
            "created_at" => "2009/08/31 21:30:54 +0000" }          
        ],
        body, code, message, headers)
      end
  when '/users/someid-valet/keys'
    case method
      when :get
        HTTParty::Response.new(
        [
          { "purpose"    => nil, 
            "api_key"    => "79f2bbc9b58132539df9deef83df1132ab4dec53",
            "id"         => "9ed7d5c84a9c410e0000010a",
            "key_type"   => "primary",
            "created_at" => "2009/08/31 21:30:54 +0000" },
          { "purpose"    => "To be more awesome", 
            "api_key"    => "79f2bbc9b58132539df9deef83df1132ab4dec55",
            "id"         => "9ed7d5c84a9c410e0000010a",
            "key_type"   => "valet",
            "created_at" => "2009/08/31 21:30:54 +0000" }          
        ],
        body, code, message, headers)
      end
      
  when '/users/badid'
    case method
    when :get
      HTTParty::Response.new([], body, code, message, headers)
    end
  
  when '/users/someid/keys/keyid'
    case method
    when :delete
      HTTParty::Response.new({"id" => "keyid"}, body, code, message, headers)    
    when :put
      HTTParty::Response.new({"id" => "keyid"}, body, code, message, headers)
    end
    
  end # case resource
end # def mock_response_for
