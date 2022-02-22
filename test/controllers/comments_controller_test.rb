# frozen_string_literal: true

require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
    test 'should save new comment for question' do
      generate_user_and_log_in 
      generate_question
      generate_text
      post "/questions/#{@question.id}/comments", params: { comment: {body: @body} }
      assert Comment.find_by(body: @body)
      assert_redirected_to "/questions/#{@question.id}?locale=en"
    end

    test 'should delete comment for question' do
      generate_user_and_log_in 
      generate_question

      generate_text
      post "/questions/#{@question.id}/comments", params: { comment: {body: @body} }
      comment = Comment.find_by(body: @body)

      delete "/questions/#{@question.id}/comments/#{comment.id}"
      refute Comment.find_by(id: comment.id)
      assert_redirected_to "/questions/#{@question.id}?locale=en"
    end

    test 'should save new comment for answer' do
      generate_user_and_log_in 
      generate_text
      generate_answer
      post "/answers/#{@answer.id}/comments", params: { comment: {body: @body} }
      assert Comment.find_by(body: @body)
      assert_redirected_to "/questions/#{@question.id}?locale=en"
    end

    test 'should delete comment for answer' do
      generate_user_and_log_in 
      generate_answer

      generate_text
      post "/answers/#{@answer.id}/comments", params: { comment: {body: @body} }
      comment = Comment.find_by(body: @body)

      delete "/answers/#{@answer.id}/comments/#{comment.id}"
      refute Comment.find_by(id: comment.id)
      assert_redirected_to "/questions/#{@question.id}?locale=en"
    end
end
