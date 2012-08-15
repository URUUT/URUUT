# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

	$('#step-1 .btn.next').click ->
		$('#step-1').hide()
		$('#step-2').show()

	$('#step-2 .btn.next').click ->
		$('#step-2').hide()
		$('#step-3').show()
		$('#new_project input[type=submit]').show()

	$('#step-2 .btn.next').click ->
		$('#step-2').hide()
		$('#step-3').show()
		$('.edit_project input[type=submit]').show()

	$('#step-2 .btn.back').click ->
		$('#step-2').hide()
		$('#step-1').show()

	$('#project_tags').tagsInput({
		'defaultText':'',
		'interactive':true,
		'removeWithBackspace' : true,
		'placeholderColor' : '#cfcfcf'
	});