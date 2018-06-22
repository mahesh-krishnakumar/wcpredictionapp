handlePredictionSubmission = ->
  $('.js-new-prediction-form').on 'ajax:success', (event) ->
    form = $(event.target)
    matchId = form.data('matchId')

    # flash success message in footer
    footerLeft = $('.js-prediction-form-footer__left--' + matchId)
    currentText = footerLeft.html()
    footerLeft.html('Prediction Saved!')
    footerLeft.addClass('text-green')
    # update 'current prediction' in footer
    setTimeout ->
      summaryText = event.detail[0].summary
      newHTML = 'Current Prediction: <span class=\'text-blue d-block d-md-inline\'>' + summaryText + '</span>'
      footerLeft.html(newHTML)
      footerLeft.removeClass('text-green')
    , 2000

    # change header styling to predicted
    header = $('#match' + matchId + '-header')
    header.addClass('match-card__header--predicted')

    # modify form to be an update form
    predictionId = event.detail[0].id
    form.attr('action', '/predictions/' + predictionId)
    $('<input>').attr({
      type: 'hidden',
      name: '_method',
      value: 'patch'
    }).appendTo(form);

    # update 'total pending predictions' count
    pendingCount = event.detail[0].total_pending
    totalCount = $('#total-predictions-count').data('matchCount')
    $('#total-predictions-count').html(pendingCount + '/' + totalCount)

    # update 'pending predictions' badge for the day
    matchDate = form.data('matchDate')
    badge = $('#pending-predictions-badge-' + matchDate)
    completedCount = event.detail[0].completed_this_day
    totalCount = badge.data('matchCount')
    if completedCount == totalCount
      badge.html('<i class=\'fa fa-check text-green\'></i>')
    else
      badge.html('<i class=\'fa fa-check-square-o text-yellow\'>&nbsp;' + completedCount + '/' + totalCount + '</i>')


  $('.js-new-prediction-form').on 'ajax:error', (event) ->
    form = $(event.target)
    matchId = form.data('matchId')
    # show error message on footer
    footerLeft = $('.js-prediction-form-footer__left--' + matchId)
    currentText = footerLeft.html()
    footerLeft.html('Something went wrong. Reloading page!')
    footerLeft.addClass('text-red')
    setTimeout ->
      location.reload(true);
    , 1000

  $('.js-new-prediction-form').on 'ajax:send', (event) ->
    form = $(event.target)
    matchId = form.data('matchId')
    footerLeft = $('.js-prediction-form-footer__left--' + matchId)
    footerLeft.removeClass('text-green text-red')
    footerLeft.html('Saving...')

handlePredictionFormChanges = ->
  $('.js-knock-out-goal-field').on 'change', (event) ->
    formRow = $(event.target).closest('.form-row')
    team1Goal = parseInt(formRow.find("input[name='prediction[team_1_goals]']").val())
    team2Goal = parseInt(formRow.find("input[name='prediction[team_2_goals]']").val())
    if team1Goal == team2Goal
      formRow.find('.js-decider-form-group').addClass('d-none')
      formRow.find('.js-winner-form-group').removeClass('d-none')
    else
      formRow.find('.js-winner-form-group').addClass('d-none')
      formRow.find('.js-decider-form-group').removeClass('d-none')

handlePredictionTableCollapse = ->
  $('.js-prediction-table__collapse').on 'show.bs.collapse', (event) ->
    matchId = $(event.target).data('matchId')
    matchStatusComplete = $(event.target).data('matchComplete')
    toggleBar = $('#prediction-table__toggle-btn-' + matchId)
    loadingSpinner = $(event.target).find('.fa-spinner')
    if matchStatusComplete
      toggleBar.html('<i class=\'fa fa-angle-double-up\'></i>&nbsp;Hide Results&nbsp;<i class=\'fa fa-angle-double-up\'></i>')
    else
      toggleBar.html('<i class=\'fa fa-angle-double-up\'></i>&nbsp;Hide Predictions&nbsp;<i class=\'fa fa-angle-double-up\'></i>')
    if loadingSpinner.length
      $(event.target).find('#show-prediction-table-' + matchId).trigger('click')
  $('.js-prediction-table__collapse').on 'hide.bs.collapse', (event) ->
    matchId = $(event.target).data('matchId')
    matchStatusComplete = $(event.target).data('matchComplete')
    toggleBar = $('#prediction-table__toggle-btn-' + matchId)
    if matchStatusComplete
      toggleBar.html('<i class=\'fa fa-angle-double-down\'></i>&nbsp;View Results&nbsp;<i class=\'fa fa-angle-double-down\'></i>')
    else
      toggleBar.html('<i class=\'fa fa-angle-double-down\'></i>&nbsp;View Predictions&nbsp;<i class=\'fa fa-angle-double-down\'></i>')

initializeSlick = ->
  initialSlide = parseInt($('.prediction-card__date-strip').data('initialSlide'))
  $('.prediction-card__date-strip').slick({
    slidesToShow: 3,
    initialSlide: initialSlide,
    infinite: false,
    asNavFor: '.prediction-card__match-strip',
    focusOnSelect: true,
    nextArrow: '.slick__next',
    prevArrow: '.slick__prev'
  })
  $('.prediction-card__match-strip').slick({
    arrows: false,
    fade: true,
    asNavFor: '.prediction-card__date-strip',
    infinite: false,
    initialSlide: initialSlide
  })


$(document).on 'turbolinks:load', ->
  if $('.prediction-card__date-strip').length
    initializeSlick()
  if $('.js-new-prediction-form').length
    handlePredictionSubmission()
  if $('.js-knock-out-goal-field').length
    handlePredictionFormChanges()
  if $('.js-prediction-table__collapse').length
    handlePredictionTableCollapse()