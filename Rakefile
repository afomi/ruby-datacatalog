require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "datacatalog"
    gem.version = '0.4.17'
    gem.rubyforge_project = "datacatalog"
    gem.summary = %Q{Client for the National Data Catalog API}
    gem.description = %Q{A Ruby client library for the National Data Catalog API}
    gem.email = "luigi@sunlightfoundation.com"
    gem.homepage = "http://github.com/sunlightlabs/datacatalog"
    gem.authors = ["Luigi Montanez", "David James"]
    gem.add_dependency('activesupport', ">= 2.3.8")
    gem.add_dependency('httparty', ">= 0.6.1")
    gem.add_dependency('mash', ">= 0.1.1")
    gem.add_dependency('version_string', ">= 0.1.0")
    gem.add_development_dependency("jeweler", ">= 1.4.0")
    gem.add_development_dependency("rspec", ">= 1.3.0")
    # gem is a Gem::Specification...
    # see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

Dir.glob(File.dirname(__FILE__) + '/tasks/*.rake').each { |f| load f }

task :default => :spec
