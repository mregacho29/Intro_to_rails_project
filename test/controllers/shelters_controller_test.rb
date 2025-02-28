require "test_helper"

class SheltersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get shelters_show_url
    assert_response :success
  end
end
