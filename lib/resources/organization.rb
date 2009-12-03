module DataCatalog

  class Organization < Base
    
    def self.all(conditions={})
      cursor(uri, query_hash(conditions))
    end

    def self.create(params={})
      one(http_post(uri, :body => params))
    end

    def self.destroy(id)
      one(http_delete(uri(id)))
    end

    def self.first(conditions={})
      _first(http_get(uri, :query => query_hash(conditions)))
    end

    def self.get(id)
      one(http_get(uri(id)))
    end

    def self.search(term)
      cursor(uri, { :search => term })
    end

    def self.update(id, params={})
      one(http_put(uri(id), :body => params))
    end

    # == Helpers

    def self.uri(id=nil)
      "/organizations/#{id}"
    end

  end

end
