$('#next-link-to-assets').unbind();
$('#next-link-to-assets').click( function (e) {
  e.preventDefault();
  if ( confirm('Are you sure? Your changes can not be changed.') ) {
    $.ajax({
      url: custom_level_url_path,
      type: 'PUT',
      data: $('[name^=level]')
    }).done(function(data) {
      console.log(data);
      /*window.location.href = '/projects/' + projectId + '/edit#assets';
      window.location.reload(true);*/
    });
  }
});