require "forwardable"

require "simple_recaptcha/version"
require "simple_recaptcha/client"

module SimpleRecaptcha
  VERIFY_URL = "http://www.google.com/recaptcha/api/verify"

  class << self
    extend Forwardable

    attr_accessor :public_key, :private_key

    def_delegators :client, :verify

    def configure
      yield self
    end

    def client
      @client ||= SimpleRecaptcha::Client.new
    end
  end
end
