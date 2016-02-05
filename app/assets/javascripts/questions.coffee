# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit-question').show()

  $('.question-votes').bind 'ajax:success', (e, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    $('.question-votes').html(JST["templates/vote"]({object: question}))

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.question-list').append(JST['templates/question']({question: question}));

  question_id = $('.question').data('questionId');
  PrivatePub.subscribe "/questions/" + question_id + "/comments", (data, channel) ->
    comment = $.parseJSON(data['comment']);
    $('.new_comment #comment_body').val('');
    $(".comments-list#question_#{comment.commentable_id}").append(JST['templates/comment']({comment: comment}));    

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
