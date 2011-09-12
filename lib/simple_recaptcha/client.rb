require "net/http"

class SimpleRecaptcha::Client
  attr_accessor :ip, :challenge, :response
  attr_writer :private_key
  attr_reader :message, :http_response

  def initialize(attributes = {})
    attributes.each { |key, value| send("#{key}=", value) }
  end

  def private_key
    @private_key ||= SimpleRecaptcha.private_key
  end

  def verified
    !!@verified
  end
  alias :verified? :verified

  def verify
    if valid?
      request and parse_response
    end
    verified?
  end

  def request
    @http_response ||= Net::HTTP.post_form(URI.parse(SimpleRecaptcha::VERIFY_URL), params)
  end

  def parse_response
    @verified, @message = http_response.body.split("\n")
    @verified = @verified == "true" ? true : false
  end

  def valid?
    ["privatekey", "remoteip", "challenge", "response"].none? { |p| params[p].nil? }
  end

  private

  def params
    {
      "privatekey" => private_key,
      "remoteip"   => ip,
      "challenge"  => challenge,
      "response"   => response
    }
  end
end
