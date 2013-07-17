$(document).ready ->

  # Switch Click
  $(".switch").click ->

    # Check If Enabled (Has 'On' Class)
    if $(this).hasClass("On")

      # Try To Find Checkbox Within Parent Div, And Check It
      $(this).parent().find("input:checkbox").attr "checked", true

      # Change Button Style - Remove On Class, Add Off Class
      $(this).removeClass("On").addClass "Off"

      $("form.registration-edit .newsletter-popover").popover
        content: "If you unsubscribe, you will no longer receive campaign updates, Uruut news, or other recurring emails. \
          You may still receive one-time emails based on your use of the site, such as confirmations for your contributions."
        placement: "top"
        trigger: "hover"

    else # If Button Is Disabled (Has 'Off' Class)
      # Try To Find Checkbox Within Parent Div, And Uncheck It
      $(this).parent().find("input:checkbox").attr "checked", false

      # Change Button Style - Remove Off Class, Add On Class
      $(this).removeClass("Off").addClass "On"

      $("form.registration-edit .newsletter-popover").popover "destroy"


  # Loops Through Each Toggle Switch On Page
  $(".switch").each ->

    # Search of a checkbox within the parent
    if $(this).parent().find("input:checkbox").length

      # This just hides all Toggle Switch Checkboxs
      # Uncomment line below to hide all checkbox's after Toggle Switch is Found
      # $(this).parent().find('input:checkbox').hide();

      # For Demo, Allow showing of checkbox's with the 'show' class
      # If checkbox doesnt have the show class then hide it
      $(this).parent().find("input:checkbox").hide()  unless $(this).parent().find("input:checkbox").hasClass("show")

      # Comment / Delete out the above 2 lines when using this on a real site

      # Look at the checkbox's checkked state
      if $(this).parent().find("input:checkbox").is(":checked")

        # Checkbox is not checked, Remove the On Class and Add the Off Class
        $(this).removeClass("On").addClass "Off"
      else

        # Checkbox Is Checked Remove Off Class, and Add the On Class
        $(this).removeClass("Off").addClass "On"

