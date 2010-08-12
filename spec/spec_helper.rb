require File.dirname(__FILE__) + '/../lib/datacatalog'
require File.dirname(__FILE__) + '/setup_api'

Spec::Runner.configure do |config|
  config.mock_with :rr
end

alias :executing :lambda

KLASSES = [
  DataCatalog::BrokenLink,
  DataCatalog::Category,
  DataCatalog::Categorization,  
  DataCatalog::Comment,
  DataCatalog::Document,
  DataCatalog::Download,
  DataCatalog::Favorite,
  DataCatalog::Import,
  DataCatalog::Importer,
  DataCatalog::Note,
  DataCatalog::Organization,
  DataCatalog::Rating,
  DataCatalog::Report,
  DataCatalog::Source,
]

def clean_slate
  DataCatalog::User.all.each do |u|
    DataCatalog::User.destroy(u.id) unless u.name == "Primary Admin"
  end
  KLASSES.each do |klass|
    to_delete = []
    klass.all.each { |instance| to_delete << instance.id }
    to_delete.each { |id| klass.destroy(id) }
  end
end

def mangle(string)
  array = string.chars.to_a
  sliced = []
  array.each_slice(2) { |s| sliced << s.reverse }
  result = sliced.flatten.join
  raise "mangle failed" if result == string
  result
end
