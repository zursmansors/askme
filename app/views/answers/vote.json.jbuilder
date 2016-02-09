json.extract! @votable, :id
json.rating @votable.votes.rating
json.user_voted @votable.user_voted? current_user
json.vote_up_url vote_up_answer_path(id: @votable, question_id: @votable.question_id)
json.vote_down_url vote_down_answer_path(@votable, question_id: @votable.question_id)
json.vote_reset_url vote_reset_answer_path(@votable, question_id: @votable.question_id)