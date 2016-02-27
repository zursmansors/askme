require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :body }

  it_behaves_like 'Attachable'
  it_behaves_like 'Commentable'

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'best answer' do
    before { answer.best }

    it 'should have setting as the best' do
      answer.set_best
      answer.reload
      expect(answer).to be_best
    end

    it 'should be the first in the answers list' do
      question.answers.reload
      expect(question.answers.first).to eq answer
    end
  end

  it 'should notify users' do
    expect(NotifyUsersJob).to receive(:perform_later).with(question)
    Answer.create!(attributes_for(:answer).merge(question: question, user: user))
  end
end