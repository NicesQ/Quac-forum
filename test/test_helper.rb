ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)

  fixtures :all

  def generate_data
    @email = Faker::Internet.email
    @password = 'QwErTy1@3'
    @name = Faker::Lorem.word
  end

  def generate_user_and_log_in
    generate_data
    @user = User.create(email: @email, name: @name, password: @password, password_confirmation: @password, old_password: @password)
    @user.save!
    post session_path, params:{ email: @user.email, name: @user.name, password: @password, password_confirmation: @password } 
  end

  def generate_question
    generate_user_and_log_in
    title = Faker::Hipster.sentence(word_count: 5)
    body = Faker::Lorem.paragraph(sentence_count: 7, supplemental: true, random_sentences_to_add: 4)
    post questions_path params: { question: {title: title, body: body} }
    @question = Question.find_by(title: title)
  end

  def generate_answer
    generate_user_and_log_in
    generate_question
    generate_text
    post "/questions/#{@question.id}/answers", params: { answer: {body: @body} }
    @answer = Answer.find_by(body: @body)
  end

  def generate_text
    @body = Faker::Lorem.paragraph(sentence_count: 7, supplemental: true, random_sentences_to_add: 4)
  end
end
