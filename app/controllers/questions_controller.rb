# frozen_string_literal: true

class QuestionsController < ApplicationController
  include QuestionsAnswers
  before_action :set_question, only: %i[show destroy edit update]

  def show
    load_question_answers
  end

  def destroy
    @question.destroy
    flash[:success] = t('.success')
    redirect_to questions_path
  end

  def edit
    redirect_to root_path unless current_user_check?(@question)
  end

  def update
    if current_user_check?(@question)
      if @question.update question_params
        flash[:success] = t('.success')
        redirect_to questions_path
      else
        render :edit
      end
    else
      redirect_to root_path
    end
  end

  def index
    @pagy, @questions = pagy Question.order(created_at: :desc)
    @questions = @questions.decorate
  end

  def new
    @question = Question.new
    redirect_to new_session_path unless user_signed_in?
  end

  def create
    @question = current_user.questions.build question_params
    if @question.save
      flash[:success] = t('.success')
      redirect_to questions_path
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find params[:id]
  end
end
