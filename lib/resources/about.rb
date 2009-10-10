require 'version_string'

module DataCatalog

  class About < Base
    
    def self.get()
      one(http_get("/"))
    end
    
    def self.version_at_least?(minimum)
      actual = VersionString.new(get.version)
      floor = VersionString.new(minimum)
      actual >= floor
    end
    
  end
  
end
