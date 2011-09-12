require "minitest/autorun"
require "mocha"

require "simple_recaptcha"

class MiniTest::Unit::TestCase
  def teardown
    SimpleRecaptcha.public_key = nil
    SimpleRecaptcha.private_key = nil
  end

  def mock_http(body = "false\ninvalid-request-cookie")
    http = mock("Net::HTTPOK")
    http.stubs(:body => body)
    Net::HTTP.stubs(:post_form).returns(http)
  end
end
