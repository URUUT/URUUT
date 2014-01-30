$ ->
  change_step = ->
    $("#step1, #step2, .step_name").toggle()

  validate_field = ->
    $("#step1 input:blank").length == 0

  $("#next-step").click ->
    if validate_field()
      change_step()
    else
      show_errors()

  $("#previous").click ->
      change_step()