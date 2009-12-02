module DataCatalog

  class Source < Base
    
    def self.all(conditions={})
      many(http_get(uri, :query => query_hash(conditions)))
    end

    def self.create(params={})
      one(http_post(uri, :body => params))
    end

    def self.destroy(id)
      one(http_delete(uri(id)))
    end

    def self.first(conditions={})
      one(http_get(uri, :query => query_hash(conditions)).first)
    end

    def self.get(id)
      one(http_get(uri(id)))
    end

    def self.search(term)
      many(http_get(uri, :query => { :search => term.downcase }))
    end

    def self.update(id, params={})
      one(http_put(uri(id), :body => params))
    end

    # == Helpers

    def self.uri(id=nil)
      "/sources/#{id}"
    end

  end
  
end
