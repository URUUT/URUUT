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
    if $("#card_number").val() is ""
      $("#card_number").addClass "error-validated-field"
    else
      $("#card_number").removeClass "error-validated-field"
    if $("#card_code").val() is ""
      $("#card_code").addClass "error-validated-field"
    else
      $("#card_code").removeClass "error-validated-field"
    if $("#card_month").val() is ""
      $("#card_month").addClass "error-validated-field"
    else
      $("#card_month").removeClass "error-validated-field"
    if $("#card_year").val() is ""
      $("#card_year").addClass "error-validated-field"
    else
      $("#card_year").removeClass "error-validated-field"
    if $("#name").val() is ""
      $("#name").addClass "error-validated-field"
    else
      $("#name").removeClass "error-validated-field"
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
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)
      return false

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
    if $("#card_number").val() is ""
      $("#card_number").addClass "error-validated-field"
    else
      $("#card_number").removeClass "error-validated-field"
    if $("#card_code").val() is ""
      $("#card_code").addClass "error-validated-field"
    else
      $("#card_code").removeClass "error-validated-field"
    if $("#card_month").val() is ""
      $("#card_month").addClass "error-validated-field"
    else
      $("#card_month").removeClass "error-validated-field"
    if $("#card_year").val() is ""
      $("#card_year").addClass "error-validated-field"
    else
      $("#card_year").removeClass "error-validated-field"
    if $("#name").val() is ""
      $("#name").addClass "error-validated-field"
    else
      $("#name").removeClass "error-validated-field"
    Stripe.createToken(card, edit_subscription.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('input#donation_token').attr('value', response.id)
      $('input#donation_card_last4').attr('value', response.card.last4)
      $('input#donation_card_type').attr('value', response.card.type)
      $('.edit_donation')[0].submit()
      # return false
    else
      console.log response
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)
      return false


$ ->
	$('#new_donation #donate').on 'click', (event) ->
    event.preventDefault()
    Stripe.setPublishableKey('pk_test_WRrfoQLUDkpGHAxCmOY0Y6ud')
    if $(".choiced-perk").attr("style") isnt "display:none" and $("#custom_amount").val() is "0"
      alert "You Can't Input 0 For Seed Amount"
    else
      # if $('#card_number').val() == ''
        # $('#new_donation')[0].submit()
      # else
        new_subscription.setupForm()

  $('.edit_donation #donate').on 'click', (event) ->
    event.preventDefault()
    Stripe.setPublishableKey('pk_test_WRrfoQLUDkpGHAxCmOY0Y6ud')
    if $(".choiced-perk").attr("style") isnt "display:none" and $("#custom_amount").val() is "0"
      alert "You Can't Input 0 For Seed Amount"
    else
      # if $('#card_number').val() == ''
      #   $('.edit_donation')[0].submit()
      # else
        edit_subscription.setupForm()
