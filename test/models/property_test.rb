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
