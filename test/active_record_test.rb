require 'helper'
require 'active_support/version'

if ActiveSupport::VERSION::STRING < "3.0.0"
  class Model < ActiveRecord::Base # :nodoc:
    attr_accessor :what
  
    def self.columns
      []
    end
    def self.connection
    end
  end
else
  class Model
    include ActiveModel
    attr_accessor :id, :what
  end
end

class ActiveRecordTest < MiniTest::Unit::TestCase # :nodoc:
  def setup
    BackgroundLite::Config.default_handler = [:test, :forget]
    BackgroundLite::Config.default_error_reporter = :test
  end
  
  def teardown
    BackgroundLite::TestHandler.reset
    BackgroundLite::TestErrorReporter.last_error = nil
  end
  
  def test_should_correctly_marshal_active_record_objects
    model = Model.new
    model.id = 10
    assert_equal model.id, Marshal.load(Marshal.dump(model.clone_for_background)).id
  end
  
  def test_should_correctly_marshal_singleton_active_record_objects
    model = Model.new
    model.id = 10
    def model.some_method
    end
    
    assert_equal model.id, Marshal.load(Marshal.dump(model.clone_for_background)).id
  end
  
  def test_should_correctly_marshal_active_record_instance_variables
    model = Model.new
    model.what = 10
    
    assert_equal model.what, Marshal.load(Marshal.dump(model.clone_for_background)).what
  end
end
