require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
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

  test 'valid signup information with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'foobarbaz',
                                         password_confirmation: 'foobarbaz' } }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user) # assigns lets us access instance variables in the corresponding action
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    # assert_select 'div.alert.alert-success'  # would be brittle as the flash key or div might change
    assert_not flash.empty?

  end
end
