# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

getHash = ->
  if window.location.hash
    $('.step-container').each ->
      $(this).hide()
		
    $('.breadcrumbs li').each ->
      $(this).removeClass('active')
		
    hashVal = window.location.hash.split("#")[1]
    console.log hashVal
    if hashVal == 'sponsor-info' 
      $("[data-id='" + hashVal + "']").show()
      stopJoyride()
      $('.breadcrumbs li[class*="' + hashVal + '"]').addClass('active')
  
    if hashVal == 'project-details' 
      $("[data-id='" + hashVal + "']").show() 
      stopJoyride()
      $('li.' + hashVal).addClass('active')
  
    if hashVal == 'perks'
      $("[data-id='" + hashVal + "']").show()
      stopJoyride()
      $('.breadcrumbs li[class*="' + hashVal + '"]').addClass('active')
  
    if hashVal == 'sponsorship' 
      $("[data-id='" + hashVal + "']").show()
      stopJoyride()
      $('.breadcrumbs li[class*="' + hashVal + '"]').addClass('active')
  
    if hashVal == 'assets' 
      $("[data-id='" + hashVal + "']").show()
      startJoyride()
      $('.breadcrumbs li[class*="' + hashVal + '"]').addClass('active')
     
  else
    window.location.href = "/projects/" + projectId + "/edit#sponsor-info"
    window.location.reload(true)
		
startJoyride = ->      
  $('#uruutTour').joyride({autoStart : true})
  $('.quit-tour').click (e) ->
    e.preventDefault()
    stopJoyride()
		
stopJoyride = ->
  $('#uruutTour').joyride('destroy')

$ ->
  $('#stepDesc1').click ->
    console.log "clicked"
    $('#step0').hide()
    $('#step1').show()	
  
  #
  # Saving form values in local storage when connecting to stripe to deal with
  # clearing form fields when returning.
  #
	 
  $('.stripe-connect').click ->
    localStorage.setItem('organization', $('#project_organization').val())
    localStorage.setItem('address', $('#project_address').val())
    localStorage.setItem('city', $('#project_city').val())
    localStorage.setItem('state', $('#project_state').val())
    localStorage.setItem('zip', $('#project_zip').val())
    localStorage.setItem('website', $('#project_website').val())
    localStorage.setItem('twitter_handle', $('#project_twitter_handle').val())
    localStorage.setItem('facebook_page', $('#project_facebook_page').val())

  if localStorage.getItem('organization') != 'undefined'
    console.log localStorage.getItem('organization')
    $('#project_organization').val(localStorage.getItem('organization'))

  if localStorage.getItem('address') != 'undefined'
    $('#project_address').val(localStorage.getItem('address'))

  if localStorage.getItem('city') != 'undefined'
    $('#project_city').val(localStorage.getItem('city'))

  if localStorage.getItem('state') != 'undefined'
    $('#project_state').val(localStorage.getItem('state'))

  if localStorage.getItem('zip') != 'undefined'
    $('#project_zip').val(localStorage.getItem('zip'))

  if localStorage.getItem('website') != 'undefined'
    $('#project_website').val(localStorage.getItem('website'))

  if localStorage.getItem('twitter_handle') != 'undefined'
    $('#project_twitter_handle').val(localStorage.getItem('twitter_handle'))

  if localStorage.getItem('facebook_page') != 'undefined'
    $('#project_facebook_page').val(localStorage.getItem('facebook_page'))

  #
  # Add another perk for sponsors
  #

  $(".add-another").click (e)->
    divCore = $(this).parent().children("#custom-checkbox")
    checkFieldP = $(this).parent().children("#custom-checkbox").children(".checkbox").children(".add_benefits")
    console.log checkFieldP
    checkboxName = checkFieldP.attr("id").split("_")[0]
    console.log checkboxName
    checkboxVal = checkFieldP.attr("id").split("_")[2]
    console.log checkboxVal
    countCheckbox = parseInt(checkboxVal) + 1

    $("#" + checkboxName + "-count").val(countCheckbox)
    $('<div class="checkbox default"><input id="' + checkboxName + '_' + countCheckbox + '" type="checkbox" value="1" name="' + checkboxName + '[' + countCheckbox + ']"><input id="' + checkboxName + '_info_' + countCheckbox + '" class="" type="text" style="margin-top: -33px width: 80% !important" placeholder="Create your costum benefit here..." name="' + checkboxName + '[info_' + countCheckbox + ']"></div>').appendTo(divCore)
    countCheckbox++
    return false
		
  #
  # Edit perks inline for sponsorship levels
  #
	
  $(".edit-benefit").click ->
    nameBenefits = $(this).parent().children("#name")
    fieldBenefits = $(this).parent().children(".edit-text-field")
    console.log c = this 
    if $(this).text() == "select to edit"
      nameBenefits.hide()
      fieldBenefits.show()
      fieldBenefits.attr("style", "margin-top:-25px width: 320px !important")
      $(this).text("save")
      $(this).addClass("btn")
      $(this).attr("style", "position: relative top: 70px !important margin-left: 5px")
      $(this).removeClass("green-font")
    else
      nameBenefits.text($(this).parent().find(".edit-text-field").val())
      nameBenefits.show()
      fieldBenefits.hide()
      $(this).removeClass("btn")
      $(this).removeAttr("style", "position: relative top: 70px !important margin-left: 5px")
      $(this).addClass("edit-benefit italic green-font")
      $(this).text("select to edit")
			
  #
  # Sponsorship levels
  #
	
  platinumSum = $('#platinum-box').children().children('.default').length
  goldSum = $('#gold-box').children().children('.default').length
  silverSum = $('#silver-box').children().children('.default').length
  bronzeSum = $('#bronze-box').children().children('.default').length

  $("#platinum-count").val(platinumSum + 1)
  $(".platinum_benefits").attr("name", "platinum[info_" + (platinumSum + 1) + "]")
  $(".platinum_benefits").attr("id", "platinum_info_" + (platinumSum + 1))
  $(".box_platinum_benefits").attr("name", "platinum[" + (platinumSum + 1) + "]")
  $(".box_platinum_benefits").attr("id", "platinum_" + (platinumSum + 1))

  $("#gold-count").val(goldSum + 1)
  $(".gold_benefits").attr("name", "gold[info_" + (goldSum + 1) + "]")
  $(".gold_benefits").attr("id", "gold_info_" + (goldSum + 1))
  $(".box_gold_benefits").attr("name", "gold[" + (goldSum + 1) + "]")
  $(".box_gold_benefits").attr("id", "gold_" + (goldSum + 1))

  $("#silver-count").val(silverSum + 1)
  $(".silver_benefits").attr("name", "silver[info_" + (silverSum + 1) + "]")
  $(".silver_benefits").attr("id", "silver_info_" + (silverSum + 1))
  $(".box_gold_benefits").attr("name", "silver[" + (silverSum + 1) + "]")
  $(".box_gold_benefits").attr("id", "silver_" + (silverSum + 1))

  $("#bronze-count").val(bronzeSum)
  $(".bronze_benefits").attr("name", "bronze[info_" + (bronzeSum + 1) + "]")
  $(".bronze_benefits").attr("id", "bronze_info_" + (bronzeSum + 1))
  $(".box_gold_benefits").attr("name", "bronze[" + (bronzeSum + 1) + "]")
  $(".box_gold_benefits").attr("id", "bronze_" + (bronzeSum + 1))
	
  #
  # Project Creation Wizard
  #

  $('.add-perk').on 'click', (e) ->
    e.preventDefault()
    console.log document.location.hostname
    name = $('#perk-name').val()
    amount = $('#perk-amount').val()
    description = $('#perk-description').val()
    project = projectId
    data = {name: name, amount: amount, description: description, project: project}
    $.ajax
      type: 'POST'
      url: 'http://' + document.location.hostname + ":" + document.location.port + '/projects/add_perk'
      data: data
    .done (data) ->
      console.log data
      window.location.reload(true)
    .error (error) ->
      console.log error

  $('.update-perk').on 'click', (e) ->
    e.preventDefault()
    name = $('#perk-name').val()
    amount = $('#perk-amount').val()
    description = $('#perk-description').val()
    perk_id = $('#perk-id').val()
    data = {name: name, amount: amount, description: description, id: perk_id}
    $.ajax
      type: 'POST'
      url: 'http://' + document.location.hostname + ":" + document.location.port + '/projects/update_perk'
      data: data
    .done (data) ->
      console.log data
      window.location.reload(true)
	
  $('.perk-delete').on 'click', (e) ->
    e.preventDefault()
    perk_id = $(this).parent().find('input[type=hidden]').val()
    console.log perk_id
    data = {id: perk_id}
    $.ajax
      type: 'POST'
      url: 'http://' + document.location.hostname + ":" + document.location.port + '/projects/delete_perk'
      data: data
    .done (data) ->
      console.log(data)
      window.location.reload(true)

  $('.created-perk .perk-edit').on 'click', ->
    $.ajax
      type: 'POST'
      url: getPerkProjectUrl
      data: {id: $(this).parent().find('input[type=hidden]').val()}
    .done (data) ->
      $('#perk-name').val(data.name)
      $('#perk-amount').val(data.amount)
      $('#perk-description').val(data.description)
      $('#perk-id').val(data.id)
      $('.add-perk').hide()
      $('.update-perk').show()
	
  $('li.submit a').click (e) ->
    e.preventDefault()
    console.log #{@project.id}
    $.ajax
      type:'POST'
      url: submitUrl
      data: 
        id: projectId
    .done (data) ->
      if data == "successful"
        window.location.href = thankYouUrl
				
  #
  # Project Wizard Form Submit
  #
	
  $('.step-container').on 'form', 'submit', ->
    console.log "form submitted"
    return $(this).h5Validate()
	
  $('.step-container[data-id="sponsor-info"] form').on 'submit', (e) ->
    if $('#connected').val() == 'true'
     e.preventDefault()
     data = $(this).serialize()
     $.ajax
       type: 'POST'
       url: projectPath
       data: data
     .done (data) ->
       console.log "Success???"
       console.log data 
       window.location.href = '/projects/' + data + '/edit#project-details'
       window.location.reload(true)
       localStorage.clear()
     .error (error) ->
       console.log error
    else
      alert "Connect with Stripe, please."
      return false
	
  $('.step-container[data-id="project-details"] form').on 'submit', (e) ->
    e.preventDefault()
    console.log "prevent worked"
    data = $(this).serialize()
    console.log data
    $.ajax
      type: 'POST'
      url: projectPath
      data: data
    .done (data) ->
      console.log "Success???"
      window.location.href = '/projects/' + data + '/edit#perks'
      window.location.reload(true)
	
  $('.step-container[data-id="perks"] form').on 'submit', (e) ->
    e.preventDefault()
    console.log "prevent worked"
    data = $(this).serialize()
    console.log data 
    $.ajax
      type: 'POST'
      url: projectPath
      data: data
    .done (data) ->
      console.log "Success???"
      window.location.href = '/projects/' + data + '/edit#sponsorship'
      window.location.reload(true)
	
  $('.step-container[data-id="sponsorship"] form').on 'submit', (e) ->
    e.preventDefault()
    console.log "prevent worked"
    data = $(this).serialize()
    console.log data
    $.ajax
      type: 'POST'
      url: projectPath
      data: data
    .done (data) ->
      console.log "Success???"
      console.log data
      window.location.href = '/projects/' + data + '/edit#assets'
      window.location.reload(true)
			
  #
  # Project Wizard Breadcrumbs
  #
	
  $('.breadcrumbs li').hover ->
    $(this).addClass('active')
  , ->
    hash = window.location.hash.split("#")[1]
    if $(this).hasClass(hash)
      $(this).addClass('active')
    else
      $(this).removeClass('active')
	
  #
  # Large Image Swap
  #
			
  $("#large_image").delegate '.pick-cover-photo', 'load', ->
    $("#uruutTour").joyride
      autoStart : true
      'tipLocation': 'bottom'

  # map = L.map('map').setView([51.505, -0.09], 13)
  getHash()
  $(window).on 'hashchange', ->
    getHash()