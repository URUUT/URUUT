# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	geocoder = ''
	address = ''
	map = ''
	codeAddress = ''
	userLocation = 'http://api.wipmania.com/jsonp?callback=?'
	window.getLocation = $.getJSON userLocation, (data)->
		console.log(data)
		
	$('ul.nav li').hover ->
		$(this).children('div').css('display', 'block') 
	,->
		$(this).children('div').css('display', 'none')

	$('#duration').datepicker({altField: '#project_duration', altFormat: 'yy-mm-dd'})
	
	$('#project_description').redactor()
	
	
	$("div.project div.location img").click ->
	  console.log "hello"
  
  #$('.short_description').hover ->
    #$('.short_description').tooltip()
		
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