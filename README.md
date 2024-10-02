# Easy broker exercise

The main idea for this exercise is to use a third api service, and then use a filter to show only titles in result. The requirements ask for tests too.

In this github link, you could be able to see the required application with all well. Because the requirements ask for gist, this file were created, followind that, I'll add some script in this file.
https://github.com/vichuge/EasyBrokerTest

## Script list

### Controller

```ruby
class Api::V1::PropertiesController < ApplicationController
  def index
    data = Property.data_from_api
    if data && data["content"]
      titles = data["content"].map { |p| p["title"] }
      render json: titles, status: :ok
    else
      render json: { error: "Failed to retrieve data" }, status: :bad_request
    end
  end
end
```

### Model

```ruby
class Property < ApplicationRecord
  validates :title, presence: true
  def self.data_from_api
    service = EasyBrokerService.new("https://api.stagingeb.com/v1/properties")
    service.fetch_data
  end
end
```

### Service

```ruby
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
```

### Tests

```ruby
require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  test "should not save property without title" do
    property = Property.new
    assert_not property.save, "Saved the property without a title"
  end

  test "should save property with a title" do
    property = Property.new(title: "Sample Title")
    assert property.save, "Failed to save the property with a valid title"
  end
end
```

### .env

```ruby
THIRD_PARTY_API_KEY=l7u502p8v46ba3ppgvj5y2aad50lb9
```