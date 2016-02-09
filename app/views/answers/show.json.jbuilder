json.extract! @answer, :id, :question_id, :body, :user_id
json.rating @answer.votes.rating
json.user_voted @answer.user_voted?(current_user)
json.vote_up_url vote_up_question_answer_path(id: @answer, question_id: @answer.question_id)
json.vote_down_url vote_down_question_answer_path(@answer, question_id: @answer.question_id)
json.vote_reset_url vote_reset_question_answer_path(@answer, question_id: @answer.question_id)
json.destroy_url question_answer_path(id: @answer.id, question_id: @answer.question_id)
json.set_best_url set_best_question_answer_path(@answer, question_id: @answer.question_id)

json.attachments @answer.attachments do |a|
  json.id a.id
  json.title a.file.identifier
  json.url a.file.url
end