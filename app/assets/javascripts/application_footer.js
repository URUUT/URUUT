//= require_self
//= require_tree ./behaviors

/*
  Transform data to query's syntax to be used on URL
  @params: data [object Object]
  @return: [string]
  Example:
   encodeQueryData({ name: 'plus' });
   it returns "name=plus"
 */
function encodeQueryData(data)
{
   var ret = [];
   for (var d in data)
      ret.push(encodeURIComponent(d) + "=" + encodeURIComponent(data[d]));
   return ret.join("&");
}
