handlePredictionSubmission = ->
  $('.js-new-prediction-form').on 'ajax:success', (event) ->
    form = $(event.target)
    matchId = form.data('matchId')

    # show success message on footer
    footerLeft = $('.js-prediction-form-footer__left--' + matchId)
    currentText = footerLeft.html()
    footerLeft.html('Prediction Saved!')
    footerLeft.addClass('text-green')

    # change header styling to predicted
    header = $('#match' + matchId + '-header')
    header.addClass('match-card__header--predicted')

    # modify form to be an update form
    predictionId = event.detail[0].prediction.id
    form.attr('action', '/predictions/' + predictionId)
    $('<input>').attr({
      type: 'hidden',
      name: '_method',
      value: 'patch'
    }).appendTo(form);

    # update 'total pending predictions' count
    predictedCount = event.detail[0].matches_predicted.length
    totalCount = $('#total-predictions-count').data('matchCount')
    pendingCount = totalCount - predictedCount
    $('#total-predictions-count').html(pendingCount + '/' + totalCount)

  $('.js-new-prediction-form').on 'ajax:error', (event) ->
    form = $(event.target)
    matchId = form.data('matchId')
    # show error message on footer
    footerLeft = $('.js-prediction-form-footer__left--' + matchId)
    currentText = footerLeft.html()
    footerLeft.html('Something went wrong. Try again!')
    footerLeft.addClass('text-red')

  $('.js-new-prediction-form').on 'ajax:send', (event) ->
    form = $(event.target)
    matchId = form.data('matchId')
    footerLeft = $('.js-prediction-form-footer__left--' + matchId)
    footerLeft.removeClass('text-green text-red')
    footerLeft.html('Saving...')

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
    if (teamOneScore != teamTwoScore) && $(event.target).closest('div.form-group').find('.js-decider-select').val() == 'Penalty'
      $(event.target).closest('div.form-group').find('input[type=submit]').attr('disabled', true)
      $(event.target).closest('div.form-group').find('div.prediction-form__score-danger-alert').removeClass('d-none')
      $(event.target.parentElement).find('input[type=number]').addClass('prediction-form__score-input--error')

  $('.js-decider-select').on 'change', (event) ->
    teamOneScore = parseInt($(event.target).closest('div.form-group').find('input[type=number]')[0].value)
    teamTwoScore = parseInt($(event.target).closest('div.form-group').find('input[type=number]')[1].value)
    selectedValue = $('.js-decider-select').val()

    if selectedValue == 'Penalty'
      $('.prediction-form__penalty-winner').removeClass('d-none')
    else
      $('.prediction-form__penalty-winner').addClass('d-none')
      $('.js-winner-select').val('')

    if selectedValue == 'Penalty' && teamOneScore == teamTwoScore
      $('.prediction-form__score-danger-alert').addClass('d-none')
      $('.js-knockout-score').removeClass('prediction-form__score-input--error')
      $(event.target).closest('div.form-group').find('input[type=submit]').attr('disabled', false)

    if (selectedValue == 'Extra Time' || selectedValue == 'Regular') && (teamOneScore == teamTwoScore)
      $('.prediction-form__score-danger-alert').removeClass('d-none')
      $(event.target).closest('div.form-group').find('input[type=submit]').attr('disabled', true)
      $('.js-knockout-score').addClass('prediction-form__score-input--error')
    else
      $('.prediction-form__score-danger-alert').addClass('d-none')
      $('.js-knockout-score').removeClass('prediction-form__score-input--error')
      $(event.target).closest('div.form-group').find('input[type=submit]').attr('disabled', false)

initializeSlick = ->
  $('.prediction-card__date-strip').slick({
    slidesToShow: 5,
    infinite: false,
    asNavFor: '.prediction-card__match-strip',
    focusOnSelect: true,
    nextArrow: '.slick__next',
    prevArrow: '.slick__prev',
    responsive: [
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 3
        }
      }
    ]
  })
  $('.prediction-card__match-strip').slick({
    arrows: false,
    fade: true,
    asNavFor: '.prediction-card__date-strip',
    infinite: false
  })


$(document).on 'turbolinks:load', ->
  initializeSlick()
  if $('.js-new-prediction-form').length
    handlePredictionSubmission()