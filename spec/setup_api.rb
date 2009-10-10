require 'yaml'
require File.dirname(__FILE__) + '/../lib/datacatalog'

def setup_api
  config = YAML.load_file(File.dirname(__FILE__) + '/../sandbox_api.yml')
  DataCatalog.api_key = config['api_key']
  DataCatalog.base_uri = config['base_uri']
end
