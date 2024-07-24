# frozen_string_literal: true

require 'test_helper'

class ProfileControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get profile_show_url
    assert_response :success
  end

  test 'should get edit' do
    get profile_edit_url
    assert_response :success
  end

  test 'should get update' do
    get profile_update_url
    assert_response :success
  end

  test 'should get new' do
    get profile_new_url
    assert_response :success
  end

  test 'should get create' do
    get profile_create_url
    assert_response :success
  end

  test 'should get destroy' do
    get profile_destroy_url
    assert_response :success
  end
end
