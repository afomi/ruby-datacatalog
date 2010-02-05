require 'rubygems'
require 'active_support'
gem 'httparty'
require 'httparty'
require 'mash'

require File.dirname(__FILE__) + '/main'
require File.dirname(__FILE__) + '/connection'
require File.dirname(__FILE__) + '/base'
require File.dirname(__FILE__) + '/cursor'
Dir.glob(File.dirname(__FILE__) + '/resources/*.rb').each { |f| require f }
