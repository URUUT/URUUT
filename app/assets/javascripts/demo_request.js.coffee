$ ->
  change_step = ->
    $(".error-box").hide();
    $("#step1, #step2, .step_name").toggle()
    $("#step1 input").removeClass('error')

  validate_field = ->
    $("#step1 input:blank").length == 0

  show_errors = ->
    $(".error-box").show();
    $("#step1 input:blank").addClass('error')

  $("#next-step").click ->
    # if validate_field()
      change_step()
    # else
      # show_errors()

  $("#previous").click ->
      change_step()