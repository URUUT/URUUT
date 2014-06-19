/*
  Expresion /(\d+)/g
  Search any digit on path. According to project_path
 */
var PROJECT_ID = location.pathname.match(/(\d+)/g)[0];

!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');

$("#button-seed-custom").on("click", function(){
  var data = {
    amount: $("#custom_seed").val(),
    name:   'custom',
    project_id: PROJECT_ID
  }
  var request = $.get("/default_perk_donations", data);
  request.done(function(response) {
    window.location.href = "/default_perk_donations?" + encodeQueryData(data);
  });
});

$(document).ready(function(){
  $('.donor-anonymous').tooltip();
  $("a[rel^='prettyPhoto']").prettyPhoto();

  $('.unsignin').click(function(){
    sign_url = '#{request.protocol}' + document.location.hostname + ":" + document.location.port + $(this).attr("url-data")
    url = $(this).attr("url-data");
    $('.modal').remove();
    $('body').append('<div class="modal hide fade" style="text-align:center;padding:50px;"><button type="button" class="close" data-dismiss="modal" aria-hidden="true" style="position:absolute;top:10px;right:20px;">×</button><h5 style="margin-bottom:20px;">You need to sign in or sign up before continuing.</h5><a href="'+ url +'" class="btn green-btn">Sign In ►</a> <span style="font:italic 12px/21px georgia, serif;margin:0 10px;">or</span> <a href="/projects/set_previous_path_for_registration?url='+ sign_url +'" class="btn green-btn">Sign Up ►</a></div>');
    $('.modal').modal();
  });
});

var getFbCount = function() {
  var url = [ location.protocol,
    '//graph.facebook.com/fql?q=select%20%20like_count%20from%20link_stat%20where%20url=%22',
    location.host, '/projects/', PROJECT_ID, '%22'].join('');
  $.ajax({
    type: "GET",
    dataType: 'jsonp',
    url: url
  }).done(function(response) {
    if ( response.data.length > 0 ) {
      $('.fb-count span').text(data.data[0].like_count);
    } else {
      $('.fb-count span').text(0);
      console.info('Not like counts yet');
    }
  });
}

var getTwCount = function() {
  var data = [location.host, '/projects/', PROJECT_ID].join('');
  $.ajax({
    type: "GET",
    dataType: 'jsonp',
    url: location.protocol + '//cdn.api.twitter.com/1/urls/count.json?url=' + data
  }).done(function(data) {
    $('.tw-count span').text(data.count);
  });
}

$(function(){
  $('#myTab1 a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });

  $('#myTab2 a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });

  getFbCount();
  getTwCount();

  var activeTab = $('.nav-tabs li.active a').attr('href');

  var geocoder = new google.maps.Geocoder();
  var geocoderRequest = { address: $('.project-location > div').text() };
  geocoder.geocode(geocoderRequest, function(results, status){
    var latitude = results[0].geometry.location.lat();
    var longitude = results[0].geometry.location.lng();

    var map = L.map('map', {
        scrollWheelZoom: false
    }).setView([latitude,longitude], 11);

    var uruutIcon = L.icon({
      iconUrl: $('#map').data('icon'),
      iconSize:     [36, 52]
    });

    L.tileLayer("https://stamen-tiles.a.ssl.fastly.net/toner-lite/{z}/{x}/{y}.png", {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>'
    }).addTo(map);

    L.marker([latitude,longitude], {icon:uruutIcon}).addTo(map);
  });

  $(activeTab).show();

  $('.nav-tabs li a').click(function(e){
    e.preventDefault();
    var show = $(this).attr('href');

    $('.nav-tabs li').removeClass('active');
    $('.nav-tabs li').each(function(){
      var content = $(this).find('a').attr('href');
      $(content).hide();
    });

    $(this).parent('li').addClass('active');
    $(show).show();
  });

  $('.tw-count').click(function(e) {
    e.preventDefault();
    var width  = 575,
        height = 400,
        left   = ($(window).width()  - width)  / 2,
        top    = ($(window).height() - height) / 2,
        url    = "#{request.protocol}twitter.com/share?url=#{project_url(@project.id)}&text=Like%20making%20a%20difference?%20Check%20out%20this%20great%20project%20I%20found....%20&hashtags=Uruut",
        opts   = 'status=1' +
                 ',width='  + width  +
                 ',height=' + height +
                 ',top='    + top    +
                 ',left='   + left;

    window.open(url, 'twitter', opts);
  })

});
