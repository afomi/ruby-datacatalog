module DataCatalog

  class Source < DataCatalog::Base
    
    class << self
      alias_method :_get, :get
    end
      
    def self.all(conditions={})
      set_up!
      response_for{ _get("/sources", :query => conditions) }.map do |source|
        build_object(source)
      end
    end

    def self.create(params={})
      set_up!
      build_object(response_for { post("/sources", :query => params) })
    end

    def self.destroy(source_id)
      set_up!
      response_for { delete("/sources/#{source_id}") }
      true
    end
    
    def self.first(conditions={})
      set_up!
      response = response_for { _get("/sources", :query => conditions) }
      build_object(response[0])
    end

    def self.get(id)
      set_up!
      build_object(response_for { _get("/sources/#{id}") })
    end
    
    def self.update(source_id, params={})
      set_up!
      build_object(response_for { put("/sources/#{source_id}", :query => params) })
    end

  end
  
end
