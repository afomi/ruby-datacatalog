module DataCatalog

  module Connection
    extend self
    include HTTParty

    DEFAULT_BASE_URI = 'http://api.nationaldatacatalog.com'

    format :json
    base_uri DEFAULT_BASE_URI
    default_params :api_key => DataCatalog.api_key
  end

end
