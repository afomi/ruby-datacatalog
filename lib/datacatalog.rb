require 'rubygems'
require 'httparty'
require 'activesupport'

module DataCatalog
  mattr_accessor :api_key, :base_uri
  class Error               < RuntimeError; end
  class ApiKeyUndefined     < Error; end
  class BadRequest          < Error; end # 400
  class Unauthorized        < Error; end # 401
  class NotFound            < Error; end # 404
  class InternalServerError < Error; end # 500
end

Dir["#{File.dirname(__FILE__)}/datacatalog/*.rb"].each { |source_file| require source_file }