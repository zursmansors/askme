require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:other_user) { create(:user) }
  let(:foreign_question) { create(:question, user: other_user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(question)
    end

      it 'renders index view' do
        expect(response).to render_template :index
      end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders :show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question to the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'have connection between signed user and question' do
        sign_in(user)
        post :create, question:attributes_for(:question)
        expect(assigns(:question).user).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question in the database' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        question.reload
        expect(assigns(:question)).to eq question
      end

      it 'render update template' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil }, format: :js }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
        expect(assigns(:question)).to eq question
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { question }

    context 'Authenticated user deletes his own question' do
      let(:question) {create(:question, user: @user)}

      it 'delete the question' do
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'Authenticated user delete not his own question' do

      it 'should not delete the question' do
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'PATCH #vote_up' do
    sign_in_user
    let(:question) { create(:question, user: @user) }

    it 'increase vote for smb question' do
      expect { patch :vote_up, id: foreign_question, format: :json }.to change(foreign_question.votes, :count)
      expect(foreign_question.votes.rating).to eq 1
      expect(response).to render_template :vote
    end

    it 'does not change vote for own question' do
      expect { patch :vote_up, id: question, format: :json }.to_not change(question.votes, :count)
    end
  end

  describe 'PATCH #vote_down' do
    sign_in_user
    let(:question) { create(:question, user: @user) }

    it 'decrease vote for smb question' do
      expect { patch :vote_down, id: foreign_question, format: :json }.to change(foreign_question.votes, :count)
      expect(foreign_question.votes.rating).to eq -1
      expect(response).to render_template :vote
    end

    it 'does not change vote for own question' do
      expect { patch :vote_down, id: question, format: :json }.to_not change(question.votes, :count)
    end
  end

  describe 'PATCH #vote_reset' do
    sign_in_user

    it 'reset vote for smb question' do
      patch :vote_up, id: foreign_question, format: :json
      expect { patch :vote_reset, id: foreign_question, format: :json }.to change(foreign_question.votes, :count)
      expect(foreign_question.votes.rating).to eq 0
      expect(response).to render_template :vote
    end
  end
end
