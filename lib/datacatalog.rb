require 'rubygems'
require 'httparty'
require 'activesupport'

module DataCatalog
  mattr_accessor :api_key, :base_uri
  class ApiKeyUndefined < RuntimeError; end
  class BadRequest < RuntimeError; end            # 400
  class RequestUnauthorized < RuntimeError; end   # 401
  class ResourceNotFound < RuntimeError; end      # 404
  class InternalServerError < RuntimeError; end   # 500
end

Dir["#{File.dirname(__FILE__)}/datacatalog/*.rb"].each { |source_file| require source_file }