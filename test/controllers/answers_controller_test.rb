# frozen_string_literal: true

require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest

    test 'should save new answer' do
      generate_user_and_log_in 
      generate_text
      generate_question

      post "/questions/#{@question.id}/answers", params: { answer: {body: @body} }
      assert Answer.find_by(body: @body)
      assert_redirected_to "/questions/#{@question.id}?locale=en"
    end

    test 'should delete answer' do
      generate_user_and_log_in 
      generate_answer
      
      delete "/questions/#{@question.id}/answers/#{@answer.id}"
      refute Answer.find_by(body: @body)
      assert_redirected_to "/questions/#{@question.id}?locale=en"
    end

    test 'should get edit answer page' do
      generate_user_and_log_in 
      generate_answer
      get "/questions/#{@question.id}/answers/#{@answer.id}/edit"
      assert_response :success
    end

    test 'should edit answer and redirect to question page' do
      generate_user_and_log_in 
      generate_answer
      generate_text
      patch "/questions/#{@question.id}/answers/#{@answer.id}", params:{ answer: {body: @body} }
      assert_equal(@body,Answer.find_by(id: @answer.id).body)
      assert_redirected_to "/questions/#{@question.id}?locale=en"
    end
end

