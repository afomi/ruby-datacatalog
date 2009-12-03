module DataCatalog

  class Cursor
    
    include Enumerable
    
    def initialize(options)
      @response = options[:response]
      @klass    = options[:klass]

      @document_count = @response['document_count']
      @members        = @response['members'].map { |x| @klass.new(x) }
      @page_count     = @response['page_count']
    end
    
    def each
      @members.each { |m| yield m }
    end
    
    def [](i)
      @members[i]
    end
    
    def first
      @members.first
    end
    
    def last
      @members.last
    end

    def length
      @document_count
    end
    
    def size
      @members.size
    end

    def to_a
      @members
    end
    
  end
  
end
