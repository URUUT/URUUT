# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

new_subscription =
  setupForm: ->
    $('input[type=submit].btn').attr('disabled', true)
    if $('#card_number').length
      subscription.processCard()
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

    Stripe.createToken(card, subscription.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('input#donation_token').attr('value', response.id)
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
      subscription.processCard()
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

    Stripe.createToken(card, subscription.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('input#donation_token').attr('value', response.id)
      $('#edit_donation')[0].submit()
      # return false
    else
      console.log response
      return false
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)


$ ->
	$('#new_donation #donate').live 'click', (event) ->
    event.preventDefault()
    Stripe.setPublishableKey('pk_0EJjrLzbYh33TkSMmfGjt4upjqVOW')
    if $('#card_number').val() == ''
      $('#new_donation')[0].submit()
    else
      new_subscription.setupForm()

  $('#edit_donation #donate').live 'click', (event) ->
    event.preventDefault()
    Stripe.setPublishableKey('pk_0EJjrLzbYh33TkSMmfGjt4upjqVOW')
    if $('#card_number').val() == ''
      $('#edit_donation')[0].submit()
    else
      edit_subscription.setupForm()