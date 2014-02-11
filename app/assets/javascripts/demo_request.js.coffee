$ ->
  change_step = ->
    $(".error-box").hide();
    $("#step1, #step2, .step_name").toggle()
    $("#step1 input").removeClass('error')

  validate_field = ->
    $("#step1 input:blank").length == 0

  validate_radio = ->
    $("input[name='demo[non_profit]']:checked,
      input[name='demo[money_raised_yearly]']:checked,
      input[name='demo[type_of_accepted_donations]']:checked,
      input[name='demo[sponsorship_program]']:checked,
      input[name='demo[crowdfunding]']:checked,
      input[name='demo[crowdfunding_campaign_goals]']:checked,
      input[name='demo[partial_funding]']:checked,
      input[name='demo[seven_days_to_receive_funds]']:checked,
      input[name='demo[social_outreach]']:checked").length

  validate_step2_field = ->
    validate = true
    validate = false if $("#step2 input:blank").length > 0
    validate = false if validate_radio()
    validate

  show_errors = ->
    $(".error-box").show();
    $("#step1 input:blank").addClass('error')

  $("#next-step").click ->
    if validate_field()
      change_step()
    else
      show_errors()

  $("#previous").click ->
      change_step()

  $("#project-submit").click ->
    if validate_step2_field()
      $("#new_demo").submit()
    else
      show_errors()
    false
