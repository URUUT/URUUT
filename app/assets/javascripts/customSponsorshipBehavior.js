$('#next-link-to-assets').unbind();
$('#confirm-changes .btn-primary').click( function (e) {
  e.preventDefault();
  $.ajax({
    url: custom_level_url_path,
    type: 'PUT',
    data: $('.step-container[data-id="sponsorship"] form').serialize()
  }).done(function(data) {
    $('#confirm-changes').modal('hide');
    window.location.href = '/projects/' + projectId + '/edit#assets';
    window.location.reload(true);
  });
});
