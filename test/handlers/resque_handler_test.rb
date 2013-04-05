require 'helper'

class ResqueHandlerTest < MiniTest::Unit::TestCase

  def setup
    BackgroundLite::Config.default_handler = [:test, :forget]
    BackgroundLite::Config.default_error_reporter = :test
  end

  def teardown
    BackgroundLite::TestHandler.reset
    BackgroundLite::TestErrorReporter.last_error = nil
  end

  def subject
    BackgroundLite::ResqueHandler
  end

  class ::Resque; end;
  class MagicalToaster
    def cook_toast_without_background(slices)
      'Your toast is ready'
    end
  end

  def test_handle
    subject.stubs(:require).with('resque')
    ::Resque.expects(:enqueue).returns(true)

    assert subject.handle(MagicalToaster, 'cook_toast_without_background', 1)
  end

  def test_perform_with_valid_data
    message = "BAhbCW86JlJlc3F1ZUhhbmRsZXJUZXN0OjpNYWdpY2FsVG9hc3RlcgA6ImNv" +
              "b2tfdG9hc3Rfd2l0aG91dF9iYWNrZ3JvdW5kaQhpRw=="

    assert_equal 'Your toast is ready', subject.perform(message)
  end

  def test_perform_with_junk_marshal_data
    message = "CCCbbbWWW333XXXCCCbbbWWW333XXXCCbbbWWW333XXXCCCbbbWWW33WWW33="

    assert_raises TypeError do
      subject.perform(message)
    end
  end

  def test_perform_with_corrupt_marshal_data_that_can_still_be_unmarshalled
    message = "BAhbCWMPU3VwZXJNb2RlbDoOYXVkaXRpb24hSSIMVHVlc2RheQYB6kVGaWg="

    error = assert_raises BackgroundLite::UnableToDecodeError do
      subject.perform(message)
    end
    assert_match /marshal-structure could not create a representation/, error.message
  end

  def test_perform_with_constant_that_does_not_exist
    message = "BAhbCWMPU3VwZXJNb2RlbDoOYXVkaXRpb24hSSIMVHVlc2RheQY6BkVGaWg="

    error = assert_raises BackgroundLite::UnableToDecodeError do
      subject.perform(message)
    end
    assert_match /#{Regexp.escape('[:array, 0, 4, [:class, 1, "SuperModel"]')}/, error.message
  end

end
