class SubscribersMailer < ApplicationMailer
   def notify(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email, subject: "New answer's notifier"
  end
end