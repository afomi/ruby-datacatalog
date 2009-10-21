module DataCatalog

  class Organization < Base
    
    def self.all(conditions={})
      many(http_get("/organizations", :query => conditions))
    end

    def self.create(params={})
      one(http_post("/organizations", :body => params))
    end

    def self.destroy(organization_id)
      one(http_delete("/organizations/#{organization_id}"))
    end
    
    def self.first(conditions={})
      one(http_get("/organizations", :query => conditions).first)
    end

    def self.get(id)
      one(http_get("/organizations/#{id}"))
    end
    
    def self.update(organization_id, params={})
      one(http_put("/organizations/#{organization_id}", :body => params))
    end

  end

end
