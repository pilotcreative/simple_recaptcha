require "helper"

describe SimpleRecaptcha do
  it "should be possible to set private key on module level" do
    SimpleRecaptcha.private_key = "private"
    assert_equal "private", SimpleRecaptcha.private_key
  end

  it "should be possible to set public key on module level" do
    SimpleRecaptcha.public_key = "public"
    assert_equal "public", SimpleRecaptcha.public_key
  end

  it "should be possible to configure via block" do
    SimpleRecaptcha.configure do |config|
      config.private_key = "privateviablock"
      config.public_key = "publicviablock"
    end
    assert_equal "publicviablock", SimpleRecaptcha.public_key
    assert_equal "privateviablock", SimpleRecaptcha.private_key
  end
end
