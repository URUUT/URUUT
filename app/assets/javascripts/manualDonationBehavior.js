$('#donation-submit').on('click', function (e) {
  e.preventDefault();
  var url = this.form.getAttribute('action'),
      data = $(this.form).serialize(),
      that = this;
  this.value = 'Loading'
  var request = $.post(url, data);

  request.done(function(data, status, xhr) {
    console.log('Manual Donation was added successfully.');
  });

  request.fail(function(response, status, xhr) {
    var errors = JSON.parse(response.responseText);
    processErrors(errors, 'manual_donation');
    that.value = 'Create'
  });
})

function processErrors(errors, form) {
  for ( field in errors ) {
    el = ['#', form, '_', field].join('');
    $("#new_" + form).find(el).parents('.field').find('.error')
      .css('display', 'inline').text( errors[field].join(',') );
    $('#new_' + form).find(el).focus();
  }
}
