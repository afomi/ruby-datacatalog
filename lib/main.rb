module DataCatalog
  
  # == Exceptions
  
  class Error                     < RuntimeError; end
  class BadRequest                < Error; end # 400
  class Unauthorized              < Error; end # 401
  class Forbidden                 < Error; end # 403
  class NotFound                  < Error; end # 404
  class Conflict                  < Error; end # 409
  class InternalServerError       < Error; end # 500
  class ApiKeyNotConfigured       < Error; end
  class CannotDeletePrimaryApiKey < Error; end
  
  # == Accessors
  
  def self.api_key
    Connection.default_params[:api_key]
  end
  
  def self.api_key=(key)
    Connection.default_params[:api_key] = key
  end
  
  def self.base_uri
    Connection.base_uri
  end
  
  def self.base_uri=(uri)
    u = uri.blank? ? Connection::DEFAULT_BASE_URI : uri
    Connection.base_uri(u)
  end
  
  def self.with_key(temp_key)
    original_key = DataCatalog.api_key
    DataCatalog.api_key = temp_key
    result = yield
    DataCatalog.api_key = original_key
    result
  end

end
