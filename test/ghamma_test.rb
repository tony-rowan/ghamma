# frozen_string_literal: true

require "test_helper"

class GhammaTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Ghamma.const_defined?(:VERSION)
    end
  end
end
