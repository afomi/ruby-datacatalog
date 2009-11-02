module DataCatalog

  class Base < Mash
    
    DEFAULT_BASE_URI = 'http://api.nationaldatacatalog.com'

    include HTTParty

    format :json
    base_uri DEFAULT_BASE_URI
    
    class << self
      alias_method :_delete, :delete
      alias_method :_get,    :get
      alias_method :_post,   :post
      alias_method :_put,    :put
      
      undef_method :delete
      undef_method :get
      undef_method :post
      undef_method :put
    end
    
    def self.http_delete(path, options={})
      check_status(_delete(path, options))
    end
    
    def self.http_get(path, options={})
      check_status(_get(path, options))
    end

    def self.http_post(path, options={})
      check_status(_post(path, options))
    end

    def self.http_put(path, options={})
      check_status(_put(path, options))
    end

    # == protected
    
    def self.check_status(response)
      case response.code
      when 400: raise BadRequest,          error(response)
      when 401: raise Unauthorized,        error(response)
      when 403: raise Forbidden,           error(response)
      when 404: raise NotFound,            error(response)
      when 409: raise Conflict,            error(response)
      when 500: raise InternalServerError, error(response)
      end
      response
    end
    
    def self.error(response)
      parsed_body = JSON.parse(response.body)
      if parsed_body.empty?
        "Response was empty"
      elsif parsed_body["errors"]
        parsed_body["errors"].inspect
      else
        response.body
      end
    rescue JSON::ParserError
      "Unable to parse: #{response.body.inspect}"
    end
    
    def self.many(response)
      response.map { |item| new(item) }
    end

    def self.one(response)
      return true if response && response.respond_to?(:code) && response.code == 204
      response.blank? ? nil : new(response)
    end
    
    def self.query_hash(conditions)
      if conditions.empty?
        query_hash = {}
      else
        query_hash = { :filter => filterize(conditions) }
      end
    end
    
    def self.filterize(conditions)
      filter_string = ""
      new_conditions = {}
      conditions.each do |k,v|
        new_conditions[k.to_s] = v
      end
      new_conditions.sort.each do |k,v|
        filter_string += "#{k.to_s}:\"#{v}\" "
      end
      filter_string.strip!
    end
    
    def method_missing(method_name, *args)
      if method_name.to_s.match(/.*_(on|at)\z/)
        return Time.parse(super)
      else
        super
      end
    end

  end

end
