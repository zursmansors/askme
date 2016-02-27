class Question < ActiveRecord::Base

  include Votable
  include Commentable

  belongs_to :user
  has_many   :answers, dependent: :destroy
  has_many   :attachments, as: :attachable, dependent: :destroy
  has_many   :subscriptions, dependent: :destroy

  scope :last_day_questions, -> { where(created_at: 1.day.ago.all_day) }

  validates  :user_id, :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :created_yesterday, -> { where(created_at: Time.zone.yesterday.all_day) }
end
