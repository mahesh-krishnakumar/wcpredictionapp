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
    submitButton = details.find('input[type=submit]')

    # change header styling to predicted
    header = $('#match' + matchId + '-header')
    header.addClass('match-list__card-header--predicted')

    # modify form to be an update form
    predictionId = event.detail[0].id
    form.attr('action', '/predictions/' + predictionId)
    $('<input>').attr({
      type: 'hidden',
      name: '_method',
      value: 'patch'
    }).appendTo(form);

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
    if $(event.target).find('input[type=number]').length
      teamOneScore = parseInt($(event.target).find('input[type=number]')[0].value)
      teamTwoScore = parseInt($(event.target).find('input[type=number]')[1].value)
    if (teamOneScore == teamTwoScore) && $(event.target).find('.js-decider-select').val() != 'Penalty'
      $(event.target).find('input[type=submit]').attr('disabled', true)
      $(event.target).find('.js-knockout-score').addClass('prediction-form__score-input--error')


  $('.js-knockout-score').on 'change', (event) ->
    teamOneScore = parseInt($(event.target.parentElement).find('input[type=number]')[0].value)
    teamTwoScore = parseInt($(event.target.parentElement).find('input[type=number]')[1].value)
    if (teamOneScore == teamTwoScore) && $(event.target).closest('div.form-group').find('.js-decider-select').val() != 'Penalty'
      $(event.target).closest('div.form-group').find('input[type=submit]').attr('disabled', true)
      $(event.target).closest('div.form-group').find('div.prediction-form__score-danger-alert').removeClass('d-none')
      $(event.target.parentElement).find('input[type=number]').addClass('prediction-form__score-input--error')
    else
      $(event.target).closest('div.form-group').find('input[type=submit]').attr('disabled', false)
      $(event.target).closest('div.form-group').find('div.prediction-form__score-danger-alert').addClass('d-none')
      $(event.target.parentElement).find('.js-knockout-score').removeClass('prediction-form__score-input--error')

  $('.js-decider-select').on 'change', (event) ->
    teamOneScore = parseInt($(event.target).closest('div.form-group').find('input[type=number]')[0].value)
    teamTwoScore = parseInt($(event.target).closest('div.form-group').find('input[type=number]')[1].value)
    selectedValue = $('.js-decider-select').val()
    if selectedValue == 'Penalty'
      $('.prediction-form__penalty-winner').removeClass('d-none')
      $('.prediction-form__score-danger-alert').addClass('d-none')
      $('.js-knockout-score').removeClass('prediction-form__score-input--error')
      $(event.target).closest('div.form-group').find('input[type=submit]').attr('disabled', false)
    else
      $('.prediction-form__penalty-winner').addClass('d-none')
      $('.js-winner-select').val('')
    if (selectedValue == 'Extra Time' || selectedValue == 'Regular') && (teamOneScore == teamTwoScore)
      $('.prediction-form__score-danger-alert').removeClass('d-none')
      $(event.target).closest('div.form-group').find('input[type=submit]').attr('disabled', true)
      $('.js-knockout-score').addClass('prediction-form__score-input--error')
    else
      $('.prediction-form__score-danger-alert').addClass('d-none')
      $('.js-knockout-score').removeClass('prediction-form__score-input--error')
      $(event.target).closest('div.form-group').find('input[type=submit]').attr('disabled', false)


$(document).on 'turbolinks:load', ->
  if $('.js-new-prediction-form').length
    handlePredictionSubmission()