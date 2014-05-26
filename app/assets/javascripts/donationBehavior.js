$("#new_user").validate({
  rules: {
    "user[last_name]": { required: true },
    "user[first_name]": { required: true },
    "user[email]": { required: true, email: true },
    "user[password]": { required: true },
    "user[password_confirmation]": { required: true }
  },
  errorPlacement: function(error, element) {
    error.appendTo( element.parent().find(".error-container") );
  }
})

function submitWithUserForm () {
  if ( $('#new_user').valid() && $("#new_donation").valid() ) {
    var data = $('#new_user, #new_donation').serialize();
    Stripe.setPublishableKey(stripe_pub_key)
    var jqxhr = $.ajax({
      type: 'POST',
      dataType: 'json',
      url: $('#new_donation').attr('action'),
      data: data
    });

    jqxhr.done(function(data) {
      if ( data.user || data.donations ) {
        processErrors(data.user, 'user');
        processErrors(data.donations, 'donation');
        $("#donate").text("Contribute ►");
      } else {
        window.location.href = data.redirect;
      }
    });

    jqxhr.error(function() {
      console.log('Fail');
    });
  }
  return false;
}

function processErrors(errors, form) {
  for ( field in errors ) {
    el = ['#', form, '_', field].join('');
    $("#new_" + form).find(el).parents('.field').find('.error')
      .css('display', 'inline').text( errors[field].join(',') );
    $('#new_' + form).find(el).focus();
  }
}
