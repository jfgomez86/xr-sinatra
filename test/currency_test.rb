require 'test_helper'
require 'virtus'
require 'models/currency'

class CurrencyTest < MiniTest::Test
  include ValidAttribute::Method

  def test_validations
    currency = Currency.new
    assert_must have_valid(:base).when("USD"), currency
    assert_wont have_valid(:base).when(""), currency
    assert_must have_valid(:to).when("COP"), currency
    assert_wont have_valid(:to).when(""), currency
    assert_must have_valid(:amount).when(34.6), currency
    assert_must have_valid(:amount).when(""), currency
    assert_wont have_valid(:amount).when("sample"), currency
  end
end
