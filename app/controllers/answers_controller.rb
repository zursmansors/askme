class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :set_best]
  before_action :load_question, only: [:new, :create, :set_best]

  include Voted

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge({ user: current_user }))

    PrivatePub.publish_to("/questions/#{@question.id}/answers", answer: render_to_string('answers/show.json.jbuilder')) if @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    end
    @question = @answer.question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  def set_best
    if current_user.author_of?(@question)
      @answer.set_best
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
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end