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

  describe 'PATCH #vote_up' do
    sign_in_user
    let(:answer) { create(:answer, question: question, user: @user) }
    let(:answer_second) { create(:answer, question: question, user: user_second) }

    it 'increase vote for smb answer' do
      patch :vote_up, id: answer, question_id: question, format: :json
      answer.reload
      expect(answer.votes.rating).to eq 1
      # expect(answer.votes.upvotes.rating).to eq 1
    end

  #   it 'increase vote for smb answer' do
  #     expect { patch :vote_up, question_id: question, id: answer_second, format: :json }.to change(answer_second.votes, :count)
  #     expect(answer_second.votes.rating).to eq 1
  #     expect(response).to render_template :vote
  #   end

  #   it 'does not change vote for own answer' do
  #     expect { patch :vote_up, id: question, format: :json }.to_not change(question.votes, :count)
  #   end
  end

  # describe 'PATCH #vote_down' do
  #   sign_in_user
  #   let(:question) { create(:question, user: @user) }

  #   it 'decrease vote for smb question' do
  #     expect { patch :vote_down, id: foreign_question, format: :json }.to change(foreign_question.votes, :count)
  #     expect(foreign_question.votes.rating).to eq -1
  #     expect(response).to render_template :vote
  #   end

  #   it 'does not change vote for own question' do
  #     expect { patch :vote_down, id: question, format: :json }.to_not change(question.votes, :count)
  #   end
  # end

  # describe 'PATCH #vote_reset' do
  #   sign_in_user

  #   it 'reset vote for smb question' do
  #     patch :vote_up, id: foreign_question, format: :json
  #     expect { patch :vote_reset, id: foreign_question, format: :json }.to change(foreign_question.votes, :count)
  #     expect(foreign_question.votes.rating).to eq 0
  #     expect(response).to render_template :vote
  #   end
  # end
end