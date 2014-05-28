$("#new_sponsor").validate({
  rules: {
    "user[last_name]": { required: true },
    "user[first_name]": { required: true },
    "user[email]": { required: true, email: true },
    "user[organization]": { required: true },
    "user[password]": { required: true },
    "user[password_confirmation]": { required: true }
  },
  errorPlacement: function(error, element) {
    error.appendTo( element.parent().find(".error-container") );
  }
});

$('#user_organization').on('blur', function(){
  $('#project_sponsor_name').val( this.value );
});

$('#project-submit').click(function(e) {
  e.preventDefault();
  if ( $('#new_sponsor').valid() ) {
    var data = $('#new_sponsor').serialize();
    Stripe.setPublishableKey(stripe_pub_key)
    var jqxhr = $.ajax({
      type: 'POST',
      dataType: 'json',
      url: $('#new_sponsor').attr('action'),
      data: data
    });

    jqxhr.done(function(data) {
      if ( data.user || data.sponsor ) {
        processErrors(data.user, 'user')
        processErrors(data.sponsor, 'donation')
      } else {
        window.location.href = data.redirect;
      }
    });

    jqxhr.error(function() {
      console.log('Fail');
    });
  }
  return this;
});

function processErrors(errors, form) {
  for ( field in errors ) {
    el = ['#', form, '_', field].join('');
    $("#new_" + form).find(el).parents('.field').find('.error')
      .css('display', 'inline').text( errors[field].join(',') );
  }
  $('label.error:visible:first').parents('.field').find('input').focus();
}
