$('#cancelModal .btn-primary').on('ajax:success', function(evt, redirectURL, settings) {
  $('#cancelModal').modal('hide');
  window.location = redirectURL;
});

$('#cancelModal .btn-primary').on('ajax:error', function(evt, jxhr, settings, response) {
  $('#cancelModal').modal('hide');
  errors = JSON.parse(jxhr.responseText);
  alert(errors.message);
});
