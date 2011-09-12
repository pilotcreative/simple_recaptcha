require "helper"

describe SimpleRecaptcha::Client do
  before do
    @attributes = {:ip => "127.0.0.1", :challenge => "challenge", :response => "response", :private_key => "private_key"}
  end

  it "should set attributes on initialization" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    recaptcha.ip.must_equal "127.0.0.1"
    recaptcha.challenge.must_equal "challenge"
    recaptcha.response.must_equal "response"
    recaptcha.private_key.must_equal "private_key"
  end

  it "should be valid with all attributes set" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    recaptcha.valid?.must_equal true
  end

  it "should be invalid without ip attribute" do
    @attributes.delete(:ip)
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    recaptcha.valid?.wont_equal true
  end

  it "should be invalid without challenge attribute" do
    @attributes.delete(:challenge)
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    recaptcha.valid?.wont_equal true
  end

  it "should be invalid without respnse attribute" do
    @attributes.delete(:response)
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    recaptcha.valid?.wont_equal true
  end

  it "should be invalid without private_key attribute" do
    @attributes.delete(:private_key)
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    recaptcha.valid?.wont_equal true
  end

  it "should use module private key when not set on initialization" do
    SimpleRecaptcha.private_key = "moduleprivate"
    recaptcha = SimpleRecaptcha::Client.new
    recaptcha.private_key.must_equal "moduleprivate"
  end

  it "should overwrite module private key on initialization" do
    SimpleRecaptcha.private_key = "moduleprivate"
    recaptcha = SimpleRecaptcha::Client.new(:private_key => "instanceprivate")
    recaptcha.private_key.must_equal "instanceprivate"
  end

  it "should return true if verified" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    http = mock("Net::HTTPOK")
    http.stubs(:body => "true\n")
    Net::HTTP.stubs(:post_form).returns(http)
    recaptcha.verify.must_equal true
  end

  it "should be able to check if verified" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    http = mock("Net::HTTPOK")
    http.stubs(:body => "true\n")
    Net::HTTP.stubs(:post_form).returns(http)
    recaptcha.verify
    recaptcha.verified.must_equal true
    recaptcha.verified?.must_equal true
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
    recaptcha.verify.wont_equal true
  end

  it "should return false when not verified" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    http = mock("Net::HTTPOK")
    http.stubs(:body => "false\ninvalid-request-cookie")
    Net::HTTP.stubs(:post_form).returns(http)
    recaptcha.verify.wont_equal true
  end

  it "should be able to check if not verified" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    http = mock("Net::HTTPOK")
    http.stubs(:body => "false\ninvalid-request-cookie")
    Net::HTTP.stubs(:post_form).returns(http)
    recaptcha.verify
    recaptcha.verified.wont_equal true
    recaptcha.verified?.wont_equal true
  end

  it "should be able to read message from not verified response" do
    recaptcha = SimpleRecaptcha::Client.new(@attributes)
    http = mock("Net::HTTPOK")
    http.stubs(:body => "false\ninvalid-request-cookie")
    Net::HTTP.stubs(:post_form).returns(http)
    recaptcha.verify
    recaptcha.message.must_equal "invalid-request-cookie"
  end
end
