$('#donation-submit').on('click', function (e) {
  e.preventDefault();
  var url = this.form.getAttribute('action'),
      data = $(this.form).serialize(),
      old_value = this.value,
      that = this;
  this.value = 'Loading'

  var request = $.ajax({
    type: this.form.getAttribute('method'),
    data: data,
    url: url
  })

  request.done(function(data, status, xhr) {
    console.log('Manual Donation was added successfully.');
  });

  request.fail(function(response, status, xhr) {
    var errors = JSON.parse(response.responseText);
    processErrors(errors, 'manual_donation');
    that.value = old_value
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

$('.edit-manual-donation').on('click', function(e) {
  e.preventDefault();
  var url = this.getAttribute('href'),
      $form = $('#new_manual_donation'),
      $submit = $('#donation-submit');

  $form.attr('action', url);
  $form.attr('method', 'put');

  var request = $.get(url)
  request.done(function(manual_donation, status, xhr) {
    $form.find('input:visible').each(function (index, el) {
      /*
        We want get content inside of bracket
        Example inputs and responses
          inputs                                  responses
          manual_donation[first_name]             ["[first_name]", "first_name"]
          manual_donation[last_name]              ["[last_name]", "last_name"]
          manual_donation[email]                  ["[email]", "email"]

        Regex: /\[(.+)\]/
      */
      field = this.name.match(/\[(.+)\]/);
      if (field) {
        this.value = manual_donation[field[1]];
      }
    });

    $submit.attr('value', 'Edit');
    $form.find('input:visible').first().focus();
  });

});


$('.delete-manual-donation').on('click', function (e) {
  e.preventDefault();
  var $modal = $('#deleteModal'),
      $confirmButton = $('#confirm-delete'),
      url = this.getAttribute('href');

  $confirmButton.on('click', function(e) {
    $('.table.table-striped').html('Loading...');
    var request = $.ajax({ type: 'DELETE', url: url });
    request.done(function() {
      console.log('The element was deleted successfully');
    });
  });

  $modal.modal();
})
