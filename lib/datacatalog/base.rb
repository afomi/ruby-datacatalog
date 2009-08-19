module DataCatalog

  class Base < OpenStruct
  
    include HTTParty
    format :json
    
    def self.set_base_uri
      default_options[:base_uri] = HTTParty.normalize_base_uri(DataCatalog.base_uri || 'api.nationaldatacatalog.com')
    end
    
    def self.set_api_key
      default_options[:default_params] = {} if default_options[:default_params].nil?
      if DataCatalog.api_key.blank?
        raise ApiKeyUndefined
      else
        default_options[:default_params].merge!({:api_key => DataCatalog.api_key})
      end
    end

    def self.set_up!
      set_base_uri
      set_api_key
    end

    def self.check_status_code(response)
      raise BadRequest          if response.code == 400
      raise RequestUnauthorized if response.code == 401
      raise ResourceNotFound    if response.code == 404
      raise InternalServerError if response.code == 500
    end

    def self.response_for
      response = yield
      check_status_code(response)
      return response
    end

    def self.build_object(response)
      if response.nil? || response.empty?
        return nil
      else
        new(response)
      end
    end

    def self.about
      set_base_uri
      build_object(response_for{get('/')})
    end

  end # class Base

end # module DataCatalog