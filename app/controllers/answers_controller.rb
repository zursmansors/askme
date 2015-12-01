class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy]
  before_action :load_question, only: [:new, :create]

  def new
    @answer = @question.answers.new
  end

  def create
    # @question = Question.find(params[question_id])
    # @question.answers.create(answer_params)

    # redirect_to question_path(@question)

    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Answer has been deleted'
    else
      flash.now[:alert] = 'Not enough rights'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end
end