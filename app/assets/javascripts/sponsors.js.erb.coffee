# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

new_sponsor =
  setupForm: ->
    $('input[type=submit].btn').attr('disabled', true)
    if $('#card_number').length
      new_sponsor.processCard()
      false
    else
      $('input[type=submit].btn').attr('disabled', false)
      $('#donate')[0].submit()

  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()

    Stripe.createToken(card, new_sponsor.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      console.log response
      $('input#token').attr('value', response.id)
      $('input#project_sponsor_card_last4').attr('value', response.card.last4)
      $('input#project_sponsor_card_type').attr('value', response.card.type)
      $('#new_sponsor')[0].submit()
      false
    else
      console.log response
      return false
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)

edit_sponsor =
  setupForm: ->
    $('input[type=submit].btn').attr('disabled', true)
    if $('#card_number').length
      edit_sponsor.processCard()
      false
    else
      $('input[type=submit].btn').attr('disabled', false)
      $('#donate')[0].submit()

  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()

    Stripe.createToken(card, edit_sponsor.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('input#donation_token').attr('value', response.id)
      $('input#donation_last4').attr('value', response.card.last4)
      $('input#donation_card_type').attr('value', response.card.type)
      $('#edit_donation')[0].submit()
      # return false
    else
      console.log response
      return false
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)


$ ->
	console.log "Current Project is: " + project_pub_key
	$('#new_sponsor #project-submit').on 'click', (event) ->
    event.preventDefault()
    Stripe.setPublishableKey(project_pub_key);
    if $('#card_number').val() == ''
      $('#new_sponsor')[0].submit()
    else
      new_sponsor.setupForm()

  $('#edit_donation #donate').on 'click', (event) ->
    event.preventDefault()
    if $('#card_number').val() == ''
      $('#edit_donation')[0].submit()
    else
      edit_sponsor.setupForm()