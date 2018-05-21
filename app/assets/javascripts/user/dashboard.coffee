handlePredictionSubmission = ->
  console.log('Ready')
  $('.js-new-prediction-form').on 'ajax:success', (event) ->
    form = $(event.target)
    matchId = form.data('matchId')
    notice = $('#match' + matchId + '-details').find('.prediction-form__notice')
    notice.addClass('prediction-form__notice--predicted')
    notice.find('.prediction-form__notice-title').html('Prediction saved!')
    form.find('input[type=submit]').val('Update')

  $('.js-new-prediction-form').on 'ajax:error', (event) ->
    form = $(event.target)
    matchId = form.data('matchId')
    notice = $('#match' + matchId + '-details').find('.prediction-form__notice')
    notice.addClass('prediction-form__notice--error')
    notice.find('.prediction-form__notice-title').html('Something went wrong. Try again!')


  $('.js-new-prediction-form').on 'ajax:send', (event) ->
    form = $(event.target)
    matchId = form.data('matchId')
    notice = $('#match' + matchId + '-details').find('.prediction-form__notice')
    notice.removeClass('prediction-form__notice--error prediction-form__notice--predicted')

$(document).on 'turbolinks:load', ->
  if $('.js-new-prediction-form').length
    handlePredictionSubmission()