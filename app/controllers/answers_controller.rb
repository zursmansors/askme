 class AnswersController < ApplicationController
  before_action :load_question

  def new
    @answer = @question.answers.new
  end

  def create
    @question = Question.find(params[:question_id])
    @question.answers.create(answer_params)
    redirect_to question_path(@question)

  #   @answer = @question.answers.new(answer_params)

  #   if @answer.save
  #     redirect_to @question
  #   else
  #     render :new
  #   end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end
end
