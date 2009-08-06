module DataCatalog

  class Base
  
    include HTTParty
    format :json
    
    def self.set_base_uri
      default_options[:base_uri] = HTTParty.normalize_base_uri(DataCatalog.base_uri || 'api.nationaldatacatalog.com')
    end
    
    def self.set_default_params
      default_options[:default_params] = {} if default_options[:default_params].nil?
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
      get '/'
    end
    
  end # class Base

end # module DataCatalog