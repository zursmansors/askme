class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_answer, only: [:update, :destroy]
  before_action :load_question, only: [:new, :create,:destroy]

  def new
    @answer = @question.answers.new
  end

  def create
  
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = "Answer has been created"
      redirect_to question_path(@question)
    else
      flash[:notice] = 'Body is empty'
      render :new
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Answer has been deleted.'
      redirect_to question_path(@question)
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
    params.require(:answer).permit(:body)
  end
end