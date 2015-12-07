require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) {create(:answer, question: question, user: @user)}
  let(:question) {create(:question, user: @user)}

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer to the database' do
        expect do
          post :create,
                question_id: question,
                answer: attributes_for(:answer),
                format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create,
              question_id: question,
              answer: attributes_for(:answer),
              format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer in the database' do
        expect do
          post :create,
               answer: attributes_for(:invalid_answer),
               question_id: question,
               format: :js
        end.to_not change(Answer, :count)
      end

      it 'render new template invalid_answer' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { question; answer}

    it 'deletes the answer' do
      expect { delete :destroy, id: answer, question_id: question }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question view' do
      expect delete :destroy, id: answer, question_id: question
      expect(response).to redirect_to question_path(assigns(:question))
    end    
  end
end