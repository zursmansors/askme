require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, created_at: Date.yesterday, user: user) }
    let(:mail) { DailyMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello #{user.email}")
      expect(mail.body.encoded).to match(question.title)
    end
  end
end
