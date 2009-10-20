require File.dirname(__FILE__) + '/../lib/datacatalog'
require File.dirname(__FILE__) + '/setup_api'

Spec::Runner.configure do |config|
  config.mock_with :rr
end

alias :executing :lambda

def clean_slate
  DataCatalog::User.all.each do |u|
    DataCatalog::User.destroy(u.id) unless u.name == "Primary Admin"
  end
  DataCatalog::Source.all.each do |s|
    DataCatalog::Source.destroy(s.id)
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
