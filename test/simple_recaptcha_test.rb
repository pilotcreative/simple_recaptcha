require "helper"

describe SimpleRecaptcha do
  it "should be possible to set private key on module level" do
    SimpleRecaptcha.private_key = "private"
    SimpleRecaptcha.private_key.must_equal "private"
  end

  it "should be possible to set public key on module level" do
    SimpleRecaptcha.public_key = "public"
    SimpleRecaptcha.public_key.must_equal "public"
  end

  it "should be possible to configure via block" do
    SimpleRecaptcha.configure do |config|
      config.private_key = "privateviablock"
      config.public_key = "publicviablock"
    end
    SimpleRecaptcha.public_key.must_equal "publicviablock"
    SimpleRecaptcha.private_key.must_equal "privateviablock"
  end
end
