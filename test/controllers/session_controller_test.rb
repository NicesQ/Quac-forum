# frozen_string_literal: true
require "test_helper"

class SessionControllerTest < ActionDispatch::IntegrationTest
    test 'should get log in form' do
        get new_session_path
        assert_response :success
    end

    test 'user can sign in and will be redirected to root' do
        email = Faker::Internet.email
        password = 'QwErTy1@3'

        user = User.create(email: email, name: Faker::Lorem.word, password: password, password_confirmation: password, old_password: password)
        user.save!

        post session_path, params:{ email: user.email, password: password, password_confirmation: password } 
        
        assert_redirected_to controller: :pages, action: :index
    end

    test 'user can sign out and will be redirected to root' do
    
        delete session_path, params: {}
    
        assert_redirected_to controller: :pages, action: :index
    end
    
end
