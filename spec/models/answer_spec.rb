require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }


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
end