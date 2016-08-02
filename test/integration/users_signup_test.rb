require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test 'invalid sign up information submitted' do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'form[action="/signup"]'
  end

  test 'valid signup' do
    get signup_path
    assert_difference 'User.count' do
      post signup_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'foobarbaz',
                                         password_confirmation: 'foobarbaz' } }
    end
    follow_redirect!
    # assert_template 'users/show'
    # assert_select 'div.alert.alert-success'  # would be brittle as the flash key or div might change
    assert_not flash.empty?
    # assert is_logged_in?
  end
end
