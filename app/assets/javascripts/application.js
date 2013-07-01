// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery-1.8.3
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree ./global

$(document).ready(function(){
  for (var i=0;i<$('input[id*="amount"]').length;i++) {
    var elm = $('input[id*="amount"]')[i],
    tmp_id = elm.id;

    elm.id = "this-is-temporary";
    elm.id = tmp_id;
  }
});

function truncText (text, maxLength, ellipseText){
  ellipseText = ellipseText || '&hellip;';

  if (text.length < maxLength)
      return text;

  //Find the last piece of string that contain a series of not A-Za-z0-9_ followed by A-Za-z0-9_ starting from maxLength
  var m = text.substr(0, maxLength).match(/([^A-Za-z0-9_]*)[A-Za-z0-9_]*$/);
  if(!m) return ellipseText;

  //Position of last output character
  var lastCharPosition = maxLength-m[0].length;

  //If it is a space or "[" or "(" or "{" then stop one before.
  if(/[\s\(\[\{]/.test(text[lastCharPosition])) lastCharPosition--;

  //Make sure we do not just return a letter..
  return (lastCharPosition ? text.substr(0, lastCharPosition+1) : '') + ellipseText;
}

jQuery.extend(jQuery.validator.messages, {
  required: "Field Required",
  remote: "Please fix this field",
  email: "Please enter a valid email address",
  url: "Please enter a valid URL",
  date: "Please enter a valid date",
  dateISO: "Please enter a valid date (ISO)",
  number: "Please enter a valid number",
  digits: "Please enter only digits",
  creditcard: "Please enter a valid credit card number",
  equalTo: "Please enter the same value again",
  accept: "Please enter a value with a valid extension",
  maxlength: jQuery.validator.format("Please enter no more than {0} characters"),
  minlength: jQuery.validator.format("Please enter at least {0} characters"),
  rangelength: jQuery.validator.format("Please enter a value between {0} and {1} characters long"),
  range: jQuery.validator.format("Please enter a value between {0} and {1}"),
  max: jQuery.validator.format("Please enter a value less than or equal to {0}"),
  min: jQuery.validator.format("Please enter a value greater than or equal to {0}")
});

jQuery.validator.addMethod("requiredAmount", function(val, elem) {
  return /^[0-9]+(,[0-9]+)*$/.test(val);
}, jQuery.validator.messages.number);

jQuery.validator.addMethod("requiredUrl", function(val, elem) {
  return  /^(www)+\.[a-zA-Z0-9\-\.]+\.[a-zA-Z0-9\-\.]/.test(val);
}, jQuery.validator.messages.url);
