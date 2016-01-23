require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :value }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :votable_id }

  let(:user) { create :user }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'question voting' do
    it 'vote up' do
      question.vote_up(user)
      expect(question.votes.rating).to eq 1
    end

    it 'vote down' do
      question.vote_down(user)
      expect(question.votes.rating).to eq -1
    end

    it 'vote reset' do
      question.vote_up(user)
      question.vote_reset(user)
      expect(question.votes.rating).to eq 0
    end

    it 'can not vote twice' do
      question.vote_up(user)
      expect(question.votes.rating).to eq 1
      question.vote_up(user)
      expect(question.votes.rating).to eq 1
    end
  end

  describe 'answers voting' do
    it 'vote up' do
      answer.vote_up(user)
      expect(answer.votes.rating).to eq 1
    end

    it 'vote down' do
      answer.vote_down(user)
      expect(answer.votes.rating).to eq -1
    end

    it 'vote reset' do
      answer.vote_up(user)
      answer.vote_reset(user)
      expect(answer.votes.rating).to eq 0
    end

    it 'can not vote twice' do
      answer.vote_up(user)
      expect(answer.votes.rating).to eq 1
      answer.vote_up(user)
      expect(answer.votes.rating).to eq 1
    end
  end
end
