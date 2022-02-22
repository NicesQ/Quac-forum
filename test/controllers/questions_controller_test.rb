# frozen_string_literal: true

require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest

    def generate_question_data
      @title = Faker::Hipster.sentence(word_count: 5)
      @body = Faker::Lorem.paragraph(sentence_count: 7, supplemental: true, random_sentences_to_add: 4)
    end

    test 'should get questions list' do
      get questions_path
      assert_response :success
    end

    test 'should get question page' do
      generate_question
      get "/questions/#{@question.id}"
      assert_response :success
    end

    test 'should redirect to log in form cuz unregistered user cnt create a question' do
      get new_question_path
      assert_redirected_to controller: :sessions, action: :new
    end

    test 'should redirect to create question form cuz user is singed in' do
      generate_user_and_log_in
      get new_question_path
      assert_response :success
    end

    test 'should save new question and redirect to question list ' do
      generate_user_and_log_in 

      generate_question_data

      post questions_path params: { question: {title: @title, body: @body} }
      assert Question.find_by(title: @title)
      assert_redirected_to controller: :questions, action: :index
    end

    test 'should delete question and redirect to question list ' do
      generate_user_and_log_in 

      generate_question
      
      delete "/questions/#{@question.id}"
      refute Question.find_by(title: @title)
      assert_redirected_to controller: :questions, action: :index
    end

    test 'should get edit question page' do
      generate_user_and_log_in 
      generate_question_data
      post questions_path params: { question: {title: @title, body: @body} }
      @question = Question.find_by(title: @title)
      get "/questions/#{@question.id}/edit"
      assert_response :success
    end

    test 'should edit question and redirect to question list' do
      generate_user_and_log_in 
      generate_question
      generate_question_data
      patch "/questions/#{@question.id}", params:{ question: {title: @title, body: @body} }
      assert_equal(@body,Question.find_by(title: @title).body)
      assert_redirected_to controller: :questions, action: :index
    end
end
