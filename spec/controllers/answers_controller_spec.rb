require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      subject { post :create, answer: attributes_for(:answer), question_id: question, format: :js }

      it 'saves the new answer to the database' do
        expect { subject }.to change(@user.answers, :count).by(1)
      end

      it 'answer should be added to question' do
        expect { subject }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        subject
        expect(response).to render_template :create
      end

      it_behaves_like 'Publishable' do
        let(:channel) { "/questions/#{question.id}/answers" }
      end
    end

    context 'with invalid attributes' do
      subject { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }

      it 'does not save the answer in the database' do
        expect { subject }.to_not change(Answer, :count)
      end

      it 'render create template' do
        subject
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    subject { patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js }
    before { subject }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
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

    it 'sets best answer to true' do
      answer.reload
      expect(answer.best).to eq true
    end

    it 'assigns the question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns the answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render set_best template' do
      expect(response).to render_template :set_best
    end
  end

  it_behaves_like 'Votable', Answer do
    let(:object) { create(:answer, question: question, user: user) }
    let(:object_second) { create(:answer, question: question, user: other_user) }
  end
end