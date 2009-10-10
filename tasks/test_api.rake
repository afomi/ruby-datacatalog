namespace :spec do
  
  MIN_VERSION = '0.2.4'
  
  desc "Test API connection"
  task :test_api => [:check_dependencies] do
    require File.dirname(__FILE__) + '/../spec/setup_api'
    setup_api
    if DataCatalog::About.version_at_least?(MIN_VERSION)
      puts "API connection looks good."
    else
      version = DataCatalog::About.get.version
      puts "API connection worked but reports version #{version}."
      puts "This client library requires version #{MIN_VERSION} or higher."
    end
  end

end
