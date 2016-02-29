require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.search' do
    it 'does not search if query nil' do
      expect(Search.search(nil, 'Answer')).to be nil
    end

    %w(User Question Answer Comment).each do |resource|
      it "searches in #{resource}" do
        expect(ThinkingSphinx)
          .to receive(:search).with('something', classes: [resource.constantize])
        Search.search 'something', resource
      end
    end

    it 'searches in all models' do
      expect(ThinkingSphinx).to receive(:search).with('something', classes: [nil])
      Search.search 'something', 'All'
    end
  end
end