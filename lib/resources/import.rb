module DataCatalog

  class Import < Base
    
    def self.all(conditions={})
      cursor(uri, query_hash(conditions))
    end

    def self.get(id)
      one(http_get(uri(id)))
    end

    def self.create(params={})
      one(http_post(uri, :body => params))
    end

    def self.update(id, params={})
      one(http_put(uri(id), :body => params))
    end

    def self.destroy(id)
      one(http_delete(uri(id)))
    end

    # == Helpers
    
    def self.uri(id=nil)
      "/imports/#{id}"
    end

  end

end