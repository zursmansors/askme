ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $ ->
    $('.answer-votes').bind 'ajax:success', (e, data, status, xhr) ->
      answer = $.parseJSON(xhr.responseText)
      $(".answer-votes#answer_#{answer.id}").html(JST["templates/vote"]({object: answer}))

    question_id = $('.question').data('questionId');
    PrivatePub.subscribe "/questions/" + question_id + "/answers", (data, channel) ->
      answer = $.parseJSON(data['answer']);
      $('.new_answer #answer_body').val('');
      $('.answers').append(JST['templates/answer']({answer: answer}));

    PrivatePub.subscribe "/questions/" + question_id + "/answers/comments", (data, channel) ->
      comment = $.parseJSON(data['comment']);
      $('.new_comment #comment_body').val('');
      $(".comments-list#answer_#{comment.commentable_id}").append(JST['templates/comment']({comment: comment}));

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update