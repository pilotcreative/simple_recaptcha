require "helper"

describe SimpleRecaptcha::Client do
  before do
    @attributes = {:ip => "127.0.0.1", :challenge => "challenge", :response => "response", :private_key => "private_key"}
  end

  it "should set attributes on initialization" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    assert_equal "127.0.0.1", recaptcha.ip
    assert_equal "challenge", recaptcha.challenge
    assert_equal "response", recaptcha.response
    assert_equal "private_key", recaptcha.private_key
  end

  it "should be valid with all attributes set" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    assert recaptcha.valid?
  end

  it "should be invalid without ip attribute" do
    @attributes.delete(:ip)
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    assert !recaptcha.valid?
  end

  it "should be invalid without challenge attribute" do
    @attributes.delete(:challenge)
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    assert !recaptcha.valid?
  end

  it "should be invalid without respnse attribute" do
    @attributes.delete(:response)
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    assert !recaptcha.valid?
  end

  it "should be invalid without private_key attribute" do
    @attributes.delete(:private_key)
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    assert !recaptcha.valid?
  end

  it "should return true if verified" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    http = mock("Net::HTTPOK")
    http.stubs(:body => "true\n")
    Net::HTTP.stubs(:post_form).returns(http)
    assert recaptcha.verify
  end

  it "should be able to check if verified" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    http = mock("Net::HTTPOK")
    http.stubs(:body => "true\n")
    Net::HTTP.stubs(:post_form).returns(http)
    recaptcha.verify
    assert recaptcha.verified
    assert recaptcha.verified?
  end

  it "should not request when not valid" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    recaptcha.stubs(:valid?).returns(false)
    recaptcha.expects(:request).never
    recaptcha.verify
  end

  it "should return false when not valid during verification" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    recaptcha.stubs(:valid?).returns(false)
    assert !recaptcha.verify
  end

  it "should return false when not verified" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    http = mock("Net::HTTPOK")
    http.stubs(:body => "false\ninvalid-request-cookie")
    Net::HTTP.stubs(:post_form).returns(http)
    assert !recaptcha.verify
  end

  it "should be able to check if not verified" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    http = mock("Net::HTTPOK")
    http.stubs(:body => "false\ninvalid-request-cookie")
    Net::HTTP.stubs(:post_form).returns(http)
    recaptcha.verify
    assert !recaptcha.verified
    assert !recaptcha.verified?
  end

  it "should be able to read message from not verified response" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    http = mock("Net::HTTPOK")
    http.stubs(:body => "false\ninvalid-request-cookie")
    Net::HTTP.stubs(:post_form).returns(http)
    recaptcha.verify
    assert_equal "invalid-request-cookie", recaptcha.message
  end
end
