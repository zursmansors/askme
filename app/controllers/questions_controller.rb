class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: :create

  include Voted

  respond_to :js, :json

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.user_id = current_user.id if current_user
    gon.question_user_id = @question.user_id
    respond_with(@answer = @question.answers.build)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    current_user.author_of?(@question) ? respond_with(@question.destroy) : respond_with(@question)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def publish_question
    PrivatePub.publish_to "/questions", question: render_to_string('questions/show.json.jbuilder') if @question.valid?
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end