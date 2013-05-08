window.updateAvatar = (event)->
  console.log event.fpfile.url
  avatarImage = event.fpfile.url
  console.log avatarImage
  $('#user_avatar').val(avatarImage)
  $('img#avatar-img').attr('src', avatarImage + '/convert?w=100&h=100&fit=crop')

$ ->
  $('#projects-created').selectbox();
  $('#projects-funded').selectbox();

  $('#edit_user').fileupload
    dataType: "json"
    always: (e, data) ->
      if data.result
        $('#avatar-img').attr('src', data.result.path)
        $('#avatar-error').attr('class', 'hidden')
      else
        $('#avatar-error').attr('class', 'visible note')

  wrapper = $('<div/>').css({height:0,width:0,'overflow':'hidden'})
  file_input = $('#avatar-hide').wrap(wrapper)

  # file_input.change ->
  #   $this = $(this)
  #   $('#avatar-file').text($this.val)
  # 
  # $('#avatar-file').click ->
  #   file_input.click()

		

