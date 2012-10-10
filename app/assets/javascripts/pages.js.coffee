# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

	userLocation = 'http://api.wipmania.com/jsonp?callback=?'
	$.getJSON userLocation, (data)->
		console.log(data)

	$('ul.nav li').hover ->
		$(this).children('div').css('display', 'block') 
	,->
		$(this).children('div').css('display', 'none')

	$('#duration').datepicker({altField: '#project_duration', altFormat: 'yy-mm-dd'})
	# $('#project_description').wysihtml5({
	# 		"events": 
	# 			"paste": -> 
	# 				console.log("Pasted");
	# 				input = $('.wysihtml5-sandbox').contents().find('body').find('p');
	# 				console.log(input);
	# 				$(input).each ->
	# 					$(this).css({
	# 						display: 'block',
	# 						margin: '20px 0' });
	# 					$(this).after('<br /><br />');
	# 	});
	
	$('#project_description').redactor({
			imageUpload: '/public/images/'
		});
