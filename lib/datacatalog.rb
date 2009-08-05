require 'rubygems'
require 'httparty'
require 'activesupport'

module DataCatalog
  mattr_accessor :api_key, :base_uri
end

Dir["#{File.dirname(__FILE__)}/datacatalog/*.rb"].each { |source_file| require source_file }