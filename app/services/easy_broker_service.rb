class EasyBrokerService
  require "net/http"
  require "json"

  def initialize(endpoint)
    @endpoint = endpoint
    @api_key = ENV["THIRD_PARTY_API_KEY"]
  end

  def fetch_data
    uri = URI(@endpoint)
    request = Net::HTTP::Get.new(uri)
    request["X-Authorization"] = @api_key

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error "Failed to fetch data from API: #{e.message}"
    nil
  end
end
