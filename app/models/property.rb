class Property < ApplicationRecord
  validates :title, presence: true
  def self.data_from_api
    service = EasyBrokerService.new("https://api.stagingeb.com/v1/properties")
    service.fetch_data
  end
end
