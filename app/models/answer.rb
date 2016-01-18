class Answer < ActiveRecord::Base

  include Votable
  
  belongs_to :question
  belongs_to :user
  has_many   :attachments, as: :attachable, dependent: :destroy

  validates  :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order best: :desc }

  def set_best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best: false)
      update!(best: true)
    end
  end

end
