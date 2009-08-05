module DataCatalog
    
  class Base
  
    include HTTParty
    format :json
    
    def initialize
      DataCatalog.base_uri = 'api.nationaldatacatalog.com'  if DataCatalog.base_uri.blank?
    end
    
    def self.set_base_uri
      default_options[:base_uri] = HTTParty.normalize_base_uri(DataCatalog.base_uri)
    end
    
    def self.set_default_params
      default_options[:default_params] ||= {}
      if DataCatalog.api_key.blank?
        raise "Failed to provide API Key!"
      else
        default_options[:default_params].merge!({:api_key => DataCatalog.api_key})
      end
    end
    
    def self.set_up!
      set_base_uri
      set_default_params
    end
    
    def self.about
      set_base_uri
      get '/sources'
    end
    
  end # class Base
  
  
end # module DataCatalog