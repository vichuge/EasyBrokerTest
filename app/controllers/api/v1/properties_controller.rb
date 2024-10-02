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
