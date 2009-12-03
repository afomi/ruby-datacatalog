module DataCatalog

  class Cursor
    
    attr_reader :document_count
    attr_reader :page_count
    attr_reader :page_size
    
    include Enumerable
    
    def initialize(options)
      @klass      = options[:klass]
      @query_hash = options[:query_hash]
      @response   = options[:response]
      @uri        = options[:uri]

      @page_size      = @response['page_size']
      @document_count = @response['document_count']
      @members        = members(@response)
      @page_count     = @response['page_count']
    end
    
    def [](i)
      member_at(i)
    end

    def each
      @document_count.times { |i| yield member_at(i) }
    end
    
    def first
      member_at(0)
    end
    
    def last
      member_at(@document_count - 1)
    end

    def length
      @document_count
    end

    def page(page_number)
      page_indices(page_number).map { |i| member_at(i) }
    end
    
    def size
      @members.size
    end

    def to_a
      @document_count.map { |i| member_at(i) }
    end
    
    protected
    
    def fetch_members_near_index(index)
      page_number = page_for_index(index)
      response = response_for_page(page_number)
      fetched = members(response)
      range = page_indices(page_number)
      range.each_with_index do |i, j|
        @members[i] = fetched[j]
      end
      fetched.length
    end
    
    def member_at(index)
      if index < 0
        raise "index (#{index}) must be >= 0"
      end
      cached = @members[index]
      return nil if @document_count == 0
      return cached if cached
      fetch_members_near_index(index)
      fetched = @members[index]
      raise "cannot find find member at index #{index}" unless fetched
      fetched
    end

    def members(response)
      response['members'].map { |x| @klass.new(x) }
    end
    
    def page_for_index(index)
      (index / @page_size) + 1
    end

    def page_indices(page_number)
      min = (page_number - 1) * @page_size
      max = min + @page_size - 1
      (min .. max)
    end

    def response_for_page(page_number)
      query_hash = @query_hash.merge(:page => page_number)
      @klass.http_get(@uri, :query => query_hash)
    end

  end
  
end
