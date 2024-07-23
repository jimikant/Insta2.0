require "test_helper"

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get subscriptions_create_url
    assert_response :success
  end

  test "should get destroy" do
    get subscriptions_destroy_url
    assert_response :success
  end
end
