$(document).ready(function() {

    $.getJSON("https://quotesondesign.com/wp-json/posts?filter[orderby]=rand&filter[posts_per_page]=1&callback=", function(a) {

        $("#message").append(a[0].content + "<p>&mdash; " + a[0].title + "</p>")
        
    });
});