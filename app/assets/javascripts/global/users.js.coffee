$ ->
  # if $("#user_subscribed").attr("checked") is "checked"
  # $('form.registration-edit .newsletter-popover').popover
  #   content: "If you unsubscribe, you will no longer receive campaign updates, Uruut news, or other recurring emails. \
  #     You may still receive one-time emails based on your use of the site, such as confirmations for your contributions."
  #   placement: "top"
  #   trigger: "hover"
  # $("#user_subscribed").next().children().on "click", ->
  #   if $("#user_subscribed").attr("checked") is "checked"
  #     $("form.registration-edit .newsletter-popover").popover "destroy"
  #   else
  #     $("form.registration-edit .newsletter-popover").popover
  #       content: "If you unsubscribe, you will no longer receive campaign updates, Uruut news, or other recurring emails. \
  #         You may still receive one-time emails based on your use of the site, such as confirmations for your contributions."
  #       placement: "top"
  #       trigger: "hover"
  if $("#user_subscribed").is ":checked"
    $("form.registration-edit .newsletter-popover").popover
      content: "If you unsubscribe, you will no longer receive campaign updates, Uruut news, or other recurring emails. \
        You may still receive one-time emails based on your use of the site, such as confirmations for your contributions."
      placement: "top"
      trigger: "hover"
  else
    $("form.registration-edit .newsletter-popover").popover "destroy"

  $('.badge-wrapper .profile-badge .img-circle').popover
    placement: "top"
    trigger: "hover"
