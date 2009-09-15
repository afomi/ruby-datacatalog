require File.dirname(__FILE__) + '/../lib/datacatalog'
require 'yaml'

Spec::Runner.configure do |config|
  config.mock_with :rr
end

alias :executing :lambda

def setup_api
  config = YAML.load_file(File.dirname(__FILE__) + '/../sandbox_api.yml')
  DataCatalog.api_key = config['api_key']
  DataCatalog.base_uri = config['base_uri']
end

def clean_slate
  DataCatalog::User.all.each do |u|
    DataCatalog::User.destroy(u.id) unless u.email == "ndc@sunlightlabs.com"
  end
end
