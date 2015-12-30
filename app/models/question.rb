class Question < ActiveRecord::Base
  belongs_to :user
  has_many   :answers, dependent: :destroy
  has_many   :attachments

  validates  :user_id, :title, :body, presence: true
end
