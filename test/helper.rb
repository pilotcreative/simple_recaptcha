require "bundler/setup"

require "minitest/autorun"
require "mocha"

require "simple_recaptcha"

class MiniTest::Unit::TestCase
  def teardown
    SimpleRecaptcha.public_key = nil
    SimpleRecaptcha.private_key = nil
  end
end
