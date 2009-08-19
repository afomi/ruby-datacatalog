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
      build_object(response_for{get("/users/#{id}")})
    end
    
    def self.create(params)
      set_up!
      build_object(response_for{post("/users",:query => params)})
    end
    
  end # class User

end # module DataCatalog