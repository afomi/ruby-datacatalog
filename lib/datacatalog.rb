require 'rubygems'
require 'activesupport'
gem 'luigi-httparty'
require 'httparty'
require 'mash'

require File.dirname(__FILE__) + '/main'
require File.dirname(__FILE__) + '/base'
Dir.glob(File.dirname(__FILE__) + '/resources/*.rb').each { |f| require f }
