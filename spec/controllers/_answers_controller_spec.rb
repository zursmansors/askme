# require 'rails_helper'

# RSpec.describe AnswersController, type: :controller do
#   let(:user) { create(:user) }
#   let!(:question) { create(:question, user: user) }
#   let(:answer) { create(:answer, question: question, user: user) }

  

#   # describe 'GET #new' do
#   #   before { get :new, question_id: question }

#   #   it 'assigns a new Answer to @answer' do
#   #     expect(assigns(:answer)).to be_a_new(Answer)
#   #   end

#   #   it 'renders new view' do
#   #     expect(response).to render_template :new
#   #   end
#   # end

#   # describe 'POST #create' do

#   #   context 'with valid attributes' do
#   #     it 'saves the new answer in the database' do
#   #       expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)
#   #     end

#   #     it 'redirects to question show view' do
#   #       post :create, answer: attributes_for(:answer), question_id: question
#   #       expect(response).to redirect_to question_path(question)
#   #     end
#   #   end

#   #   context 'with invalid attributes' do
#   #     it 'does not save the answer in the database' do
#   #       expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
#   #     end

#   #     it 'redirects to question show view' do
#   #       post :create, answer: attributes_for(:invalid_answer), question_id: question
#   #       expect(response).to redirect_to question_path(question)
#   #     end
#   #   end
#   # end

#   # describe 'DELETE #destroy' do
#   #   sign_in_user

#   #   context 'User deletes his own answer' do
#   #     let!(:answer) { create(:answer, question: question, user: @user) }

#   #     it 'delete the answer' do
#   #       expect { delete :destroy, id: answer }.to change(@user.answers, :count).by(-1)
#   #     end
#   #   end

#   #   context 'User delete someone else\'s answer' do
#   #     let!(:answer) { create(:answer, question: question, user: user) }

#   #     it 'does not delete the answer' do
#   #       delete :destroy, id: answer
#   #       expect(response).to redirect_to question_path(question)
#   #     end
#   #   end
#   # end
# end
