class Answer < ActiveRecord::Base

  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many   :attachments, as: :attachable, dependent: :destroy

  validates  :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order best: :desc }

  after_create :notify_subscribers
  after_create :create_subscription_for_author

  def set_best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  private

  def notify_subscribers
    NotifyUsersJob.perform_later(question)
  end

  def create_subscription_for_author
    Subscription.find_or_initialize_by(user: self.user, question: self.question)
  end
end
