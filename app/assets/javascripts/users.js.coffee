$ ->
  $('#projects-created').selectbox();
  $('#projects-funded').selectbox();

  wrapper = $('<div/>').css({height:0,width:0,'overflow:hidden'})
  file_input = $(':file').wrap(wrapper)

  file_input.change ->
    $this = $(this)
    $('#file').text($this.val)

  $('#file').click ->
    file_input.click()
