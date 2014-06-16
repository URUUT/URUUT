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

function truncate_location_text() {
  if ($("#location :selected").text().length > 17){
    $("#location :selected").text(truncText($("#location :selected").text(), 15, "..."));
  }
};

function truncate_category_text() {
  if ($("#category :selected").text().length > 17){
    $("#category :selected").text(truncText($("#category :selected").text(), 15, "..."));
  }
};

truncate_category_text();
truncate_location_text();

$("#category").on('change',function(){
  var length = $("#category option").length;
  for (var i = 1; i < length; i++){
    $("#category option")[i].text = $("#category option")[i].attributes["data-item"].value
  }
  truncate_category_text();
});

$("#location").on('change',function(){
  var length = $("#location option").length;
  for (var i = 1; i < length; i++){
    $("#location option")[i].text = $("#location option")[i].attributes["data-item"].value
  }
  truncate_location_text();
});
