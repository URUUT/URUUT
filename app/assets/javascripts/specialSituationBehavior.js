(function() {
  var option;
  if ( $('#project_organization_type').val() === "Special Situation" ) {
    option = $('<option/>');
    option.val('N/A');
    option[0].text = 'N/A'
    $('#project_organization_classification').
      append(option).
      val('N/A').
      attr('disabled', 'disabled');
  }
})();

$('#project_organization_type').on('change', function (e) {
  var option;
  if ( this.value === "Special Situation" ) {
    option = $('<option/>');
    option.val('N/A');
    option[0].text = 'N/A'
    $('#project_organization_classification').
      append(option).
      val('N/A').
      attr('disabled', 'disabled');
  } else {
    $('option[value="N/A"]').remove();
    $('#project_organization_classification').attr('disabled', false);
  }
});
