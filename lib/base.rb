module DataCatalog

  class Base < Mash
    def self.http_delete(path, options={})
      check_status(Connection.delete(path, options))
    end

    def self.http_get(path, options={})
      check_status(Connection.get(path, options))
    end

    def self.http_post(path, options={})
      check_status(Connection.post(path, options))
    end

    def self.http_put(path, options={})
      check_status(Connection.put(path, options))
    end

    # == protected

    def self.check_status(response)
      case response.code
      when 400 then error(BadRequest,          response)
      when 401 then error(Unauthorized,        response)
      when 403 then error(Forbidden,           response)
      when 404 then error(NotFound,            response)
      when 409 then error(Conflict,            response)
      when 500 then error(InternalServerError, response)
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

    def self.error(exception_class, response)
      e = exception_class.new
      e.response_body = response.body
      parsed_response_body = begin
        JSON.parse(response.body)
      rescue JSON::ParserError
        nil
      end
      if parsed_response_body
        e.parsed_response_body = parsed_response_body
        if parsed_response_body.is_a?(Hash) && parsed_response_body["errors"]
          e.errors = parsed_response_body["errors"]
        end
      end
      raise e
    end

    def self._first(response)
      item = response['members'][0]
      item.blank? ? nil : new(item)
    end

    def self.one(response)
      begin
        return true if response && response.code == 204
      rescue NoMethodError
      end
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
        elsif v.is_a?(Integer) || v.is_a?(TrueClass) || v.is_a?(FalseClass)
          %(=#{v})
        elsif v.is_a?(Array)
          %(=#{v.join(',')})
        else
          %(="#{v}")
        end
      end
      filtered_conditions.join(" and ")
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
