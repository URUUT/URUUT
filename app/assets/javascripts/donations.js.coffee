# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

new_subscription =
  setupForm: ->
    $('input[type=submit].btn').attr('disabled', true)
    if $('#card_number').length
      new_subscription.processCard()
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

    Stripe.createToken(card, new_subscription.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('input#donation_token').attr('value', response.id)
      $('input#donation_card_last4').attr('value', response.card.last4)
      $('input#donation_card_type').attr('value', response.card.type)
      $('#new_donation')[0].submit()
      # return false
    else
      console.log response
      return false
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)

edit_subscription =
  setupForm: ->
    $('input[type=submit].btn').attr('disabled', true)
    if $('#card_number').length
      edit_subscription.processCard()
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

    Stripe.createToken(card, edit_subscription.handleStripeResponse)

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
	$('#new_donation #donate').on 'click', (event) ->
    event.preventDefault()
    Stripe.setPublishableKey('pk_test_WRrfoQLUDkpGHAxCmOY0Y6ud')
    if $('#card_number').val() == ''
      $('#new_donation')[0].submit()
    else
      new_subscription.setupForm()

  $('#edit_donation #donate').on 'click', (event) ->
    event.preventDefault()
    Stripe.setPublishableKey('pk_test_WRrfoQLUDkpGHAxCmOY0Y6ud')
    if $('#card_number').val() == ''
      $('#edit_donation')[0].submit()
    else
      edit_subscription.setupForm()