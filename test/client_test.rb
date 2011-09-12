require "helper"

describe SimpleRecaptcha::Client do
  before do
    @attributes = {:ip => "127.0.0.1", :challenge => "challenge", :response => "response", :private_key => "private_key"}
    @recaptcha = SimpleRecaptcha::Client.new
  end

  it "should set attributes on verification" do
    mock_http
    @recaptcha.verify(@attributes)
    @recaptcha.ip.must_equal "127.0.0.1"
    @recaptcha.challenge.must_equal "challenge"
    @recaptcha.response.must_equal "response"
    @recaptcha.private_key.must_equal "private_key"
  end

  it "should be valid with all attributes set" do
    @recaptcha.attributes = @attributes
    @recaptcha.valid?.must_equal true
  end

  it "should be invalid without ip attribute" do
    @attributes.delete(:ip)
    @recaptcha.attributes = @attributes
    @recaptcha.valid?.wont_equal true
  end

  it "should be invalid without challenge attribute" do
    @attributes.delete(:challenge)
    @recaptcha.attributes = @attributes
    @recaptcha.valid?.wont_equal true
  end

  it "should be invalid without respnse attribute" do
    @attributes.delete(:response)
    @recaptcha.attributes = @attributes
    @recaptcha.valid?.wont_equal true
  end

  it "should be invalid without private_key attribute" do
    @attributes.delete(:private_key)
    @recaptcha.attributes = @attributes
    @recaptcha.valid?.wont_equal true
  end

  it "should use module private key when not set on instance level" do
    SimpleRecaptcha.private_key = "moduleprivate"
    recaptcha = SimpleRecaptcha::Client.new
    recaptcha.private_key.must_equal "moduleprivate"
  end

  it "should overwrite module private key on verification" do
    SimpleRecaptcha.private_key = "moduleprivate"
    mock_http
    @attributes[:private_key] = "instanceprivate"
    recaptcha = SimpleRecaptcha::Client.new
    recaptcha.verify(@attributes)
    recaptcha.private_key.must_equal "instanceprivate"
  end

  it "should return true if verified" do
    @recaptcha.attributes = @attributes
    mock_http("true\n")
    @recaptcha.verify.must_equal true
  end

  it "should be able to check if verified" do
    @recaptcha.attributes = @attributes
    mock_http("true\n")
    @recaptcha.verify
    @recaptcha.verified.must_equal true
    @recaptcha.verified?.must_equal true
  end

  it "should not request when not valid" do
    @recaptcha.attributes = @attributes
    @recaptcha.stubs(:valid?).returns(false)
    @recaptcha.expects(:request).never
    @recaptcha.verify
  end

  it "should return false when not valid during verification" do
    @recaptcha.attributes = @attributes
    @recaptcha.stubs(:valid?).returns(false)
    @recaptcha.verify.wont_equal true
  end

  it "should return false when not verified" do
    @recaptcha.attributes = @attributes
    mock_http("false\ninvalid-request-cookie")
    @recaptcha.verify.wont_equal true
  end

  it "should be able to check if not verified" do
    @recaptcha.attributes = @attributes
    mock_http("false\ninvalid-request-cookie")
    @recaptcha.verify
    @recaptcha.verified.wont_equal true
    @recaptcha.verified?.wont_equal true
  end

  it "should be able to read message from not verified response" do
    @recaptcha.attributes = @attributes
    mock_http("false\ninvalid-request-cookie")
    @recaptcha.verify
    @recaptcha.message.must_equal "invalid-request-cookie"
  end
end
