$("#category, #location").on("change", function(){
  $(".project-all-content").html("");
  $(".loader").fadeIn("fast");
  var category = $("#category :selected").attr("data-item")
  $.ajax({
    url: "/pages/search_category_or_location",
    data: {
      "category": category,
      "city": $("#location").val()
    }
  }).done(function(data) {
    $(".loader").fadeOut("fast");
  });
});
