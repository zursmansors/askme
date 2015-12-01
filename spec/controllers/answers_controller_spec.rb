require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, user_id: user }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer in the database' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    it 'delete thier answer' do
      answer
      expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end

    it 'not delete others_answer' do
      others_answer
      expect { delete :destroy, id: others_answer }.to_not change(Answer, :count)
    end

    it 'redirect to question' do
      delete :destroy, id: answer
      expect(response).to redirect_to question_path(question)
    end
  end
end