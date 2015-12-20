require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:answer) { create(:answer, question: question, user: @user) }
  let!(:question) { create(:question, user: @user) }

  describe 'POST #create' do
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

      it 'render create template' do
        post :create,
              answer: attributes_for(:invalid_answer),
              question_id: question,
              format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer,
                     question_id: question,
                     answer: attributes_for(:answer),
                     format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, id: answer,
                     question_id: question,
                     answer: attributes_for(:answer),
                     format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, id: answer,
                     question_id: question,
                     answer: { body: 'new body'},
                     format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, id: answer,
                     question_id: question,
                     answer: attributes_for(:answer),
                     format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    before { question; answer }

    it 'deletes the answer' do
      expect { delete :destroy, id: answer, question_id: question, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'render destroy template' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #set_best' do
    let(:question) {create(:question, user: @user)}
    let(:answer) { create(:answer, question: question, user: @user) }

    before do
      patch :set_best, id: answer, question_id: question, format: :js
    end

    it 'assigns the question' do
        expect(assigns(:question)).to eq question
    end

    it 'assigns the answer' do
        expect(assigns(:answer)).to eq answer
    end

    it 'sets best answer to true' do
        answer.reload
        expect(answer.best).to eq true
    end

    it 'render set_best template' do
        expect(response).to render_template :set_best
    end
  end
end