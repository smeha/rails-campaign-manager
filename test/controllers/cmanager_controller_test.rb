require 'test_helper'

class CmanagerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cmanager_index_url
    assert_response :success
  end

end
