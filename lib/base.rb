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
    
    def self.cursor(uri, query_hash)
      Cursor.new({
        :klass      => self,
        :query_hash => query_hash,
        :response   => http_get(uri, :query => query_hash),
        :uri        => uri,
      })
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
    
    def self._first(response)
      item = response['members'][0]
      item.blank? ? nil : new(item)
    end

    def self.one(response)
      return true if response && response.respond_to?(:code) && response.code == 204
      response.blank? ? nil : new(response)
    end
    
    def self.query_hash(conditions)
      conditions == {} ? {} : { :filter => filterize(conditions) }
    end
    
    def self.filterize(arg)
      if arg.is_a?(Hash)
        filterize_hash(arg)
      elsif arg.is_a?(String)
        arg
      else
        raise ArgumentError
      end
    end
    
    def self.filterize_hash(conditions)
      filtered_conditions = conditions.map do |k, v|
        "#{k}" + if v.is_a?(Regexp)
          %(:"#{v.source}")
        elsif v.is_a?(Integer)
          %(=#{v})
        else
          %(="#{v}")
        end
      end
      filtered_conditions.join(" ")
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
