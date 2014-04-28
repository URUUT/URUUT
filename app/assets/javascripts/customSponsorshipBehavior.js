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

function parseLevelsAmout () {
  $('#level_platinum_cost').val( $('#level_platinum_cost').val().split(',').join('') )
  $('#level_gold_cost').val( $('#level_gold_cost').val().split(',').join('') )
  $('#level_silver_cost').val( $('#level_silver_cost').val().split(',').join('') )
  $('#level_bronze_cost').val( $('#level_bronze_cost').val().split(',').join('') )
}

$('#confirm-changes .btn-primary').click( function (e) {
  e.preventDefault();
  parseLevelsAmout();
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
