if ($('#projects-funded').val() == 'Funding Completed') {
  $('.project-fund .success').parent().addClass("success");
}

$('#projects-funded').change(function(){
  var status = $(this).val();
  $.ajax({
    url: "/users/get_complete_project",
    data: {
        user_id: "#{@user.id}",
        status: status
      }
  })
})
