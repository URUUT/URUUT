# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('ul.nav li').hover ->
		$(this).children('ul').css('display', 'block') 
	,->
		$(this).children('ul').css('display', 'none')
