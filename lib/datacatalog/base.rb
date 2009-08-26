module DataCatalog

  class Base < OpenStruct
  
    include HTTParty
    format :json
    
    def self.set_base_uri
      default_options[:base_uri] = HTTParty.normalize_base_uri(DataCatalog.base_uri || 'api.nationaldatacatalog.com')
    end
    
    def self.set_api_key
      if DataCatalog.api_key.blank?
        raise ApiKeyNotConfigured, "Use DataCatalog.api_key = '...'."
      end
      default_options[:default_params] = {} if default_options[:default_params].nil?
      default_options[:default_params].merge!({:api_key => DataCatalog.api_key})
    end

    def self.set_up!
      set_base_uri
      set_api_key
    end

    def self.check_status_code(response)
      case response.code
      when 400: raise BadRequest
      when 401: raise Unauthorized
      when 404: raise NotFound
      when 500: raise InternalServerError
      end
    end

    def self.response_for
      response = yield
      check_status_code(response)
      response
    end

    def self.build_object(response)
      return nil if response.nil? || response.empty?
      new(response)
    end

    def self.about
      set_base_uri
      build_object(response_for{get('/')})
    end
    
    def id
      instance_values["table"][:id]
    end
    
  end # class Base

end # module DataCatalog