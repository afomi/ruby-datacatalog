module DataCatalog

  class User < Base
    
    def self.all(conditions={})
      cursor(uri, query_hash(conditions))
    end

    def self.create(params={})
      with_api_keys(one(http_post(uri, :body => params)))
    end

    def self.destroy(id)
      one(http_delete(uri(id)))
    end

    def self.first(conditions={})
      _first(http_get(uri, :query => query_hash(conditions)))
    end
    
    def self.get(id)
      with_api_keys(one(http_get(uri(id))))
    end

    def self.get_by_api_key(api_key)
      DataCatalog.with_key(api_key) do
        checkup = one(http_get("/checkup"))
        raise NotFound if checkup.api_key != "valid"
        get(checkup.user.id)
      end
    end
    
    def self.update(id, params)
      one(http_put(uri(id), :body => params))
    end

    # == Helpers
    
    def self.with_api_keys(user)
      user.api_keys = ApiKey.all(user.id) if user
      user
    end
    
    def self.uri(id=nil)
      "/users/#{id}"
    end
    
    # == Instance Methods

    def delete_api_key!(api_key_id)
      ApiKey.destroy(self.id, api_key_id)
      update_api_keys
    end

    def generate_api_key!(params)
      ApiKey.create(self.id, params)
      update_api_keys
    end

    def update_api_key!(api_key_id, params)
      ApiKey.update(self.id, api_key_id, params)
      update_api_keys
    end
    
    protected
    
    def update_api_keys
      self.api_keys = ApiKey.all(self.id)
      user = User.get(id)
      self.application_api_keys = user.application_api_keys
      self.valet_api_keys = user.valet_api_keys
      true
    end
    
  end

end
