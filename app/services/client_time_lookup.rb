require "open-uri"
require "time"

class ClientTimeLookup
  class LookupError < StandardError; end

  def initialize(ip_address:, reader: nil, user_agent: nil)
    @ip_address = ip_address
    @reader = reader || method(:read_url)
    @user_agent = user_agent || ENV.fetch("KEYCDN_TOOLS_USER_AGENT", "keycdn-tools:http://localhost:3000/publicbanner")
  end

  def call
    payload = JSON.parse(reader.call(api_url))
    datetime = payload.dig("data", "geo", "datetime")
    timezone = payload.dig("data", "geo", "timezone")

    raise LookupError, "datetime missing from geo lookup" if datetime.blank?
    raise LookupError, "timezone missing from geo lookup" if timezone.blank?

    parsed_time = Time.find_zone(timezone)&.parse(datetime)
    raise LookupError, "datetime could not be parsed" if parsed_time.blank?

    parsed_time
  rescue JSON::ParserError, TypeError, ArgumentError, OpenURI::HTTPError, SocketError => error
    raise LookupError, error.message
  end

  private

  attr_reader :ip_address, :reader, :user_agent

  def api_url
    "https://tools.keycdn.com/geo.json?host=#{ip_address}"
  end

  def read_url(url)
    URI.open(url, "User-Agent" => user_agent, "Accept" => "application/json").read
  end
end
