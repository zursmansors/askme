class SubscribersMailer < ApplicationMailer
   def notify(user, answer)
    @answer = answer

    # mail to: user.email, subject: "New answer's notifier"
    mail to: user.email, subject: "New answer to #{answer.question.title}"
  end
end