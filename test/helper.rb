require 'rubygems'
require 'bundler/setup'

require 'active_support'
require 'active_record'
require File.dirname(__FILE__) + '/../lib/background_lite'

RAILS_ENV = 'test'

require 'minitest/autorun'
require 'mocha/setup'
