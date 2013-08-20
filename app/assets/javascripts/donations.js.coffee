# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

new_subscription =
  setupForm: ->
    $("#donate").text("LOADING")
    $('input[type=submit].btn').attr('disabled', true)
    if $("#amount").val() != "0.0"
      new_subscription.processCard()
      false
    else
      $("#donate").text("Contribute ►")
      $('input[type=submit].btn').attr('disabled', false)
      $("#stripe_error").html("You Can't Insert $0 For Amount")
      $('#donate')[0].submit()
      false

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
      $('#stripe_error').text(response.error.message)
      $("#donate").text("Contribute ►")
      $('input[type=submit]').attr('disabled', false)
      return false

edit_subscription =
  setupForm: ->
    $("#donate").text("LOADING")
    $('input[type=submit].btn').attr('disabled', true)
    if $("#amount").val() != "0.0"
      edit_subscription.processCard()
      false
    else
      $("#donate").text("Contribute ►")
      $('input[type=submit].btn').attr('disabled', false)
      $("#stripe_error").html("You Can't Insert $0 For Amount")
      $('#donate')[0].submit()
      false

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
      $('input#donation_card_last4').attr('value', response.card.last4)
      $('input#donation_card_type').attr('value', response.card.type)
      $('.edit_donation')[0].submit()
      # return false
    else
      console.log response
      $('#stripe_error').text(response.error.message)
      $("#donate").text("Contribute ►")
      $('input[type=submit]').attr('disabled', false)
      return false


$ ->
  $(":checkbox").click ->
    if $(this).is(":checked")
      $(".content-anonymous").fadeIn()
    else
      $(".content-anonymous").fadeOut()

  $("#new_donation").validate
    messages:
      year:
        required: "Fields Required"
        minlength: "At Least 4 Digits"
        maxlength: "At Most 4 Digits"
      month:
        required: "Fields Required"
        maxlength: "At Most 2 Digits"
      code:
        digits: "Only Digits"
        minlength: "At Least 3 Digits"
        maxlength: "At Most 4 Digits"
    rules:
      name:
        required: true

      "credit-card":
        required: true
        creditcard: true

      code:
        required: true
        digits: true
        minlength: 3
        maxlength: 4

      month:
        required: true
        digits: true
        maxlength: 2

      year:
        required: true
        digits: true
        minlength: 4
        maxlength: 4
    groups:
      date: "month year"
    errorPlacement: (error, element) ->
      error.appendTo element.parent().find(".error-container")

  $(".edit_donation").validate
    messages:
      year:
        required: "Fields Required"
        minlength: "At Least 4 Digits"
        maxlength: "At Most 4 Digits"
      month:
        required: "Fields Required"
        maxlength: "At Most 2 Digits"
      code:
        digits: "Only Digits"
        minlength: "At Least 3 Digits"
        maxlength: "At Most 4 Digits"
    rules:
      name:
        required: true

      "credit-card":
        required: true
        creditcard: true

      code:
        required: true
        digits: true
        minlength: 3
        maxlength: 4

      month:
        required: true
        digits: true
        maxlength: 2

      year:
        required: true
        digits: true
        minlength: 4
        maxlength: 4
    groups:
      date: "month year"
    errorPlacement: (error, element) ->
      error.appendTo element.parent().find(".error-container")

	$('#new_donation #donate').on 'click', (event) ->
    event.preventDefault()
    if $("#new_donation").valid()
      Stripe.setPublishableKey(stripe_pub_key)
      if $(".choiced-perk").attr("style") isnt "display:none" and $("#custom_amount").val() is "0"
        alert "You Can't Input 0 For Seed Amount"
      else
        new_subscription.setupForm()
        # if $('#card_number').val() == ''
          # $('#new_donation')[0].submit()
        # else

  $('.edit_donation #donate').on 'click', (event) ->
    event.preventDefault()
    if $(".edit_donation").valid()
      Stripe.setPublishableKey(stripe_pub_key)
      if $(".choiced-perk").attr("style") isnt "display:none" and $("#custom_amount").val() is "0"
        alert "You Can't Input 0 For Seed Amount"
      else
        edit_subscription.setupForm()
      # if $('#card_number').val() == ''
      #   $('.edit_donation')[0].submit()
      # else
