class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :set_best]
  before_action :load_question, only: [:new, :create, :set_best]
  after_action :publish_answer, only: :create

  include Voted

  respond_to :js, :json

  def new
    respond_with(@answer = @question.answers.new)
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.merge({ user: current_user })))
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    respond_with(@answer)
  end

  def set_best
    @answer.set_best if current_user.author_of?(@question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def publish_answer
    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render_to_string('answers/show.json.jbuilder') if @answer.valid?
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end