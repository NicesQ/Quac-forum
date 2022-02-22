require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
    
    test 'should get register form' do
        get new_user_path
        assert_response :success
    end

    test 'user with correct credentials will be registred and redirected to root' do
        generate_data

        post users_path , params:{ user: { email: @email, name: @name, password: @password, password_confirmation: @password} }
        assert User.find_by(email: @email)    
        assert_redirected_to controller: :pages, action: :index
    end

    test 'user can edit email and name without password' do
        email1 = Faker::Internet.email
        name1 = Faker::Lorem.word

        generate_user_and_log_in

        patch "/users/#{@user.id}", params:{ user: { email: email1, name: name1} }
            
        assert_redirected_to controller: :users, action: :edit
    end

    test 'user can edit password using old password' do
        generate_data
        password1 = 'New_QwErTy1@3'

        generate_user_and_log_in

        patch "/users/#{@user.id}", params:{ user: { email: @email, name: @name, password: password1, password_confirmation: password1, old_password: @password} }
            
        assert_redirected_to controller: :users, action: :edit
    end

    test 'user cant edit password without old password' do
        password1 = 'New_QwErTy1@3'

        generate_user_and_log_in

        patch "/users/#{@user.id}", params:{ user: { email: @email, name: @name, password: password1, password_confirmation: password1 } }
            
        assert_response :success
    end
end
