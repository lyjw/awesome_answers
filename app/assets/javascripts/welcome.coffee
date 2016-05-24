# Similar to $(document).ready(...)
$ ->
  a = 10

  b = 5 if a > 10

  # => removes need to .bind(this)
  # It passes _this as an object into the function
  capitalize = (string) =>
    string.charAt(0).toUpperCase() + string.slice(1)

  console.log capitalize("tam")

  $('.btn').on "click", ->
    console.log($(@).addClass("hello"))

  $('#clickie').on "click", ->
    $(@).toggleClass("btn-danger btn-primary")

# Compiles into this:
#
# (function() {
#   $(function() {
#     var a, b, capitalize;
#     a = 10;
#     if (a > 10) {
#       b = 5;
#     }
#     capitalize = (function(_this) {
#       return function(string) {
#         return string.charAt(0).toUpperCase() + string.slice(1);
#       };
#     })(this);
#     console.log(capitalize("tam"));
#     return $('.btn').on("click", function() {
#       return console.log($(this).addClass("hello"));
#     });
#   });
#
# }).call(this);
