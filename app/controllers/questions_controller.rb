class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    # if @question.save
    #   flash[:notice] = 'Your question successfully created.'
    #   redirect_to @question
    # else
    #   render :new
    # end

    # if @question.save
    #   PrivatePub.publish_to '/questions', question: @question.to_json
    #   redirect_to @question
    # else
    #   render :new
    # end

    if @question.save
      PrivatePub.publish_to "/questions", question: render_to_string('questions/show.json.jbuilder')
      flash[:notice] = 'Your question successfully created'
      redirect_to @question
    else
      render :new
    end

    # if @question.save
    #   PrivatePub.publish_to "/questions", question: @question.to_json
    #   flash[:notice] = 'Your question successfully created'
    #   redirect_to @question
    # else
    #   render :new
    # end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question has been deleted.'
    else
      redirect_to questions_path, alert: 'Not enough rights'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end