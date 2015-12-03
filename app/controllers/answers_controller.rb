class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_answer, only: [:update, :destroy]
  before_action :load_question, only: [:new, :create]

  # def new
  #   @answer = @question.answers.new
  # end

  def create
    # @question = Question.find(params[:question_id])
    # @question.answers.create(answer_params)

    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = "Answer has been created"
      redirect_to @question
    else
      render :new
    end
    # redirect_to question_path(@question)
  end

  # def create
  #   @answer = @question.answers.new(answer_params)
  #   @answer.user = current_user
  #   @answer.save
  # end

#   def update
#     if current_user.author_of?(@answer)
#       @answer.update(answer_params)
#       @question = @answer.question
#       flash.now[:notice] = 'Ответ на вопрос успешно отредактирован'
#     else
#       flash.now[:alert] = 'У вас нет прав на эти действия'
#     end
#   end

#   def destroy
#     if current_user.author_of?(@answer)
#       @answer.destroy
#       flash.now[:notice] = 'Answer has been deleted'
#     else
#       flash.now[:alert] = 'Not enough rights'
#     end
#   end

#   private

  def destroy

  end

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