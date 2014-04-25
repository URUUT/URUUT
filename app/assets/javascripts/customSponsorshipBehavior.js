$('#next-link-to-assets').unbind();
$('#confirm-changes .btn-primary').click( function (e) {
  e.preventDefault();
  if ( validate_benefits_check() ) {
    $.ajax({
      url: custom_level_url_path,
      type: 'PUT',
      data: $('.step-container[data-id="sponsorship"] form').serialize()
    }).done(function(data) {
      $('#confirm-changes').modal('hide');
      window.location.href = '/projects/' + projectId + '/edit#assets';
      window.location.reload(true);
    });
  } else {
    $('#confirm-changes').modal('hide');
    alert('You must select a benefit for each level.');
  }
});
