require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let (:answer) { create(:answer, user: user, question: question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer to the database' do
        expect do
          post :create,
                question_id: question,
                answer: attributes_for(:answer)
        end.to change(question.answers, :count).by(1)
      end

      it 'have connection between signed user and answer' do
        sign_in(user)
        post :create, question_id: question, answer:attributes_for(:answer)
        expect(assigns(:answer).user).to eq user
      end

      it 'redirects to question show view' do
        post :create,
              answer: attributes_for(:answer),
              question_id: question
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer in the database' do
        expect do
          post :create,
               answer: attributes_for(:invalid_answer),
               question_id: question
        end.to_not change(Answer, :count)
      end

      it 'render new template invalid_answer' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  let(:answer) { create(:answer, question: question, user: @user) }
  let(:not_oner_answer) { create(:answer, question: question) }

  describe 'POST #destroy' do
    sign_in_user
    it "deletes own answer" do
        answer
        expect { delete :destroy, question_id: answer.question_id, id: answer.id }.to change(Answer, :count).by(-1)
    end

    it "deletes foregin answer" do
        not_oner_answer
        expect { delete :destroy, question_id: answer.question_id, id: answer.id }.to_not change(Answer, :count)
    end

    it 'redirects to question view' do
        delete :destroy, question_id: answer.question_id, id: answer.id
        expect(response).to redirect_to question_path(answer.question)
    end
  end
end