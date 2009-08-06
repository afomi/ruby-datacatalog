require File.dirname(__FILE__) + '/../lib/datacatalog'

Spec::Runner.configure do |config|
  config.mock_with :rr
end

alias :executing :lambda
