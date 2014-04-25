$('#next-link-to-assets').unbind();

$("#confirm-changes").on('shown', function (e) {
  e.preventDefault;
  if ( !has_any_benefits() ) {
    alert('You must select a benefit for each level.');
    $('#confirm-changes').modal('hide');
  } else {
    $('#confirm-changes').modal('show');
  }
  return this;
});

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
