# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#edit_user").validate
    rules:
      "user[last_name]":
        required: true
      "user[first_name]":
        required: true
      "user[email]":
        required: true,
        email: true
    errorPlacement: (error, element) ->
      error.appendTo element.parent().find(".error-container")

  $(".contact-for").validate
    rules:
      "pages[name]":
        required: true

      "pages[email]":
        required: true
        email: true

      "pages[subject]":
        required: true

      "pages[message]":
        required: true
    errorPlacement: (error, element) ->
      error.appendTo element.parent().find(".error-container")

  $("#new_user").validate
    rules:
      "user[email]":
        required: true,
        email: true
      "user[password]":
        required: true
    errorPlacement: (error, element) ->
      error.appendTo element.parent().find(".error-container")

  $("#email-sign-up")
    .bind "ajax:error", (event, xhr, status, error) ->
      alert "error #{status}"

    .bind "ajax:success", (event, data, status, xhr) ->
      if data.created
        new_content = "<h3>You're great!</h3>"
        $("#email-sign-up").fadeOut 1000, ->
          $("#email-sign-up").empty().append(new_content).fadeIn()
      else
        $("#email-sign-up-error").show()

  # submit_filter_form = ->
  #   $("form.project-filter").submit()

  # $("form.project-filter #location").bind "change", submit_filter_form
  # $("form.project-filter #category").bind "change", submit_filter_form

	geocoder = ''
	address = ''
	map = ''
	codeAddress = ''
	
	$('.down').click ->
		$('.dropdown').toggle()

	$('ul.nav li').hover ->
		$(this).children('div').css('display', 'block')
	,->
		$(this).children('div').css('display', 'none')

	# $('#duration').datepicker({altField: '#project_duration', altFormat: 'yy-mm-dd'})


	$("div.project div.location img").click ->
	  console.log "hello"

	initialize = ->
			geocoder = new google.maps.Geocoder()
			mapOptions =
				center: new google.maps.LatLng(-34.397, 150.644)
				zoom: 8
				mapTypeId: google.maps.MapTypeId.ROADMAP

			canvas = document.getElementById("map_canvas")
			map = new google.maps.Map(canvas, mapOptions)
		codeAddress = ->
			geocoder.geocode
				address: address
			, (results, status) ->
				if status is google.maps.GeocoderStatus.OK
					map.setCenter results[0].geometry.location
					marker = new google.maps.Marker(
						map: map
						position: results[0].geometry.location
					)
				else
					alert "Geocode was not successful for the following reason: " + status

# $ ->
	$("div.project div.location img").click ->
		address = $(this).siblings("span").html().trim()
		console.log address
		initialize()
		codeAddress()
		$("#myMap").modal()

  desc = $(".short-description:visible").text().length
  console.log(desc)

	$('.breadcrumbs li').hover ->
		$(this).addClass('active')
	,->
		$(this).removeClass('active')
