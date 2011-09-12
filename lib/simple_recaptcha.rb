require "simple_recaptcha/version"
require "simple_recaptcha/client"

module SimpleRecaptcha
  VERIFY_URL = "http://www.google.com/recaptcha/api/verify"

  class << self
    attr_accessor :public_key, :private_key

    def configure
      yield self
    end
  end
end
