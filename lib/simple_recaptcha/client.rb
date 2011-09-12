require "net/http"

class SimpleRecaptcha::Client
  attr_accessor :ip, :challenge, :response
  attr_writer :private_key
  attr_reader :message

  def private_key
    @private_key ||= SimpleRecaptcha.private_key
  end

  def verified
    !!@verified
  end
  alias :verified? :verified

  def verify(attributes = {})
    self.attributes = attributes
    parse_response if valid?
    verified?
  end

  def attributes=(attributes)
    attributes.each { |key, value| send("#{key}=", value) }
  end

  def request
    Net::HTTP.post_form(URI.parse(SimpleRecaptcha::VERIFY_URL), params)
  end

  def parse_response
    @verified, @message = request.body.split("\n")
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
