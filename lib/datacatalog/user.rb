module DataCatalog

  class User < DataCatalog::Base
  
    include HTTParty
    format :json
    
    def self.all
      set_up!
      response_for{ get("/users") }.map do |user|
        build_object(user)
      end
    end
    
    def self.find(id)
      set_up!
      build_object(response_for { get("/users/#{id}") })
    end
    
    def self.create(params)
      set_up!
      build_object(response_for { post("/users", :query => params) })
    end

    def self.update(user_id, params)
      set_up!
      build_object(response_for { put("/users/#{user_id}", :query => params) })
    end
    
    def self.destroy(user_id)
      set_up!
      response = response_for { delete("/users/#{user_id}") }
      raise Error, "Unexpected Status Code" unless response.code == 200
      true
    end
    
  end # class User

end # module DataCatalog
