handlePredictionSubmission = ->
  $('.js-new-prediction-form').on 'ajax:success', (event) ->
    form = $(event.target)
    matchId = form.data('matchId')

    # change content of notice
    details = $('#match' + matchId + '-details')
    notice = details.find('.prediction-form__notice')
    deciderLabel = details.find('.prediction-form__decider-label')
    notice.addClass('prediction-form__notice--predicted')
    deciderLabel.addClass('prediction-form__decider-label--predicted')
    notice.find('.prediction-form__notice-title').html('Prediction saved!')
    deciderLabel.html('Selected Decider')


    # change header styling to predicted
    header = $('#match' + matchId + '-header')
    header.addClass('match-list__card-header--predicted')

    # auto-close details
    hideDetails = () ->
      details.collapse('hide')
    setTimeout(hideDetails, 500)

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

  $('.js-match-details').on 'show.bs.collapse', (event) ->
    detailsOpened = $(event.target)
    submitButton = detailsOpened.find('input[type=submit]')
    notice = detailsOpened.find('.prediction-form__notice')
    if (submitButton.val() != 'Update') && notice.hasClass('prediction-form__notice--predicted')
      submitButton.val('Update')

$(document).on 'turbolinks:load', ->
  if $('.js-new-prediction-form').length
    handlePredictionSubmission()