$('#next-link-to-assets').unbind();

$("#next-link-to-assets").on('click', function (e) {
  e.preventDefault;
  if ( !has_any_benefits() ) {
    $('#errorForm').modal();
    $('#errorForm .error-messages').text('You must select at least one benefit');
  } else {
    $('#confirm-changes-modal').modal();
  }
  return this;
});

function parseLevelsAmout () {
  $('#level_platinum_cost').val( $('#level_platinum_cost').val().split(',').join('') )
  $('#level_gold_cost').val( $('#level_gold_cost').val().split(',').join('') )
  $('#level_silver_cost').val( $('#level_silver_cost').val().split(',').join('') )
  $('#level_bronze_cost').val( $('#level_bronze_cost').val().split(',').join('') )
}

$('#confirm-changes-modal .btn-primary').click( function (e) {
  e.preventDefault();
  parseLevelsAmout();
  $.ajax({
    url: custom_level_url_path,
    type: 'PUT',
    data: $('.step-container[data-id="sponsorship"] form').serialize()
  }).done(function(data) {
    $('#confirm-changes-modal').modal('hide');
    window.location.href = '/projects/' + projectId + '/edit#assets';
    window.location.reload(true);
  });
});
