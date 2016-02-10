json.extract! @answer, :id, :question_id, :body, :user_id
json.rating @answer.votes.rating
json.user_voted @answer.user_voted?(current_user)
json.vote_up_url vote_up_answer_path(id: @answer, question_id: @answer.question_id)
json.vote_down_url vote_down_answer_path(@answer, question_id: @answer.question_id)
json.vote_reset_url vote_reset_answer_path(@answer, question_id: @answer.question_id)
json.destroy_url answer_path(id: @answer.id, question_id: @answer.question_id)
json.set_best_url set_best_answer_path(question_id: @answer.question_id, id: @answer.id)

json.attachments @answer.attachments do |a|
  json.id a.id
  json.title a.file.identifier
  json.url a.file.url
end

json.dom_id "#{dom_id(@answer)}"
json.insertion_template '<div class="nested-fields">
          <span class="btn btn-primary"><input type="file" name="answer[attachments_attributes][new_attachments][file]" id="answer_attachments_attributes_new_attachments_file" /></span><span class="btn btn-danger"><input type="hidden" name="answer[attachments_attributes][new_attachments][_destroy]" id="answer_attachments_attributes_new_attachments__destroy" value="false" /><a class="remove_fields dynamic" href="#"><i class="fa fa-trash-o fa-lg"></i></a></span>
</div>'

json.comments @answer.comments do |c|
  json.body = c.body
end
json.commentable_id @answer.id