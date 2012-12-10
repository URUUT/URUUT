# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#stepDesc1').click ->
    console.log "clicked"
    $('#step0').hide()
    $('#step1').show()

  $('.down').click ->
    $('.dropdown').toggle()
