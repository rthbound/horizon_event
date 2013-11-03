#require 'coveralls'
require 'simplecov'
SimpleCov.start
#Coveralls.wear!

require "minitest/autorun"

# The gem
$: << File.dirname(__FILE__) + "/../lib"
$: << File.dirname(__FILE__)
require "horizon_event/request"
require "horizon_event/key_value_pairing"
require "horizon_event/delimited"
