jQuery.noConflict();

// on load
jQuery(document).ready(function(){
  // Add grid if "grid" query string set
  if(gridDebugIsSet(document.location.search, "grid")) {
    // Add grid class to body element
    jQuery("body").toggleClass("grid");
    
    addQueryStringToMatchingLinks([document.location.host, "/"], "grid");
  }
});

/**
  
*/
function gridDebugIsSet(query, debugKey) {
  var queryString = query;
  if(queryString && queryString[0] == "?") {
    queryString = queryString.substring(1);
  
    var items = queryString.split("&");
    var found = false;
    jQuery(items).each( function(i) {
      var item = items[i];            
      if(item == debugKey) {
        found = true;
      }
    });
    return found;
  }
}

/**
  Adds the query string to all internal links
  on the page.
*/
function addQueryStringToMatchingLinks(urls, queryString) {
  var urls = urls.length ? urls : [urls];
  var internalLinksSelector = urls.map( function(url) { return "a[href^=" + url + "]"; }).join(", ");

  jQuery(internalLinksSelector).each(function(item){
    console.log(item, this);
    this.href += "?" + queryString;
  });
}