require 'rubygems'
require 'bundler/setup'

require 'active_support'
require 'active_record'
require 'background_lite'

RAILS_ENV = 'test'

require 'minitest/autorun'
require 'mocha/setup'
