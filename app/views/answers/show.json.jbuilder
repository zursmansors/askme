json.extract! @answer, :id, :question_id, :body, :user_id


json.attachments @answer.attachments do |a|
  json.title = a.file.identifier
  json.url = a.file.url
end