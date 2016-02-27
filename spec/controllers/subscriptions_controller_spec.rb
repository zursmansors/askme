require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:subscription)  { create(:subscription, user: user) }

  describe 'POST#create' do
    sign_in_user
    it 'assign to right user' do
      expect{ post :create, question_id: question, user: user, format: :js }.to change(@user.subscriptions, :count).by(1)
    end
    it 'assign to right question' do
      expect{ post :create, question_id: question, user: user, format: :js }.to change(question.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:subscription_2)  { create(:subscription, user: @user) }
    it 'delete subscription' do
      expect { delete :destroy, question_id: question, id: subscription_2.id, format: :js }.to change(Subscription, :count).by(-1)
    end
  end
end