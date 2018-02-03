var page = require('webpage').create();
page.open('http://www.ttss.krakow.pl/#?stop=77&mode=departure', function(status) {
  console.log("Status: " + status);
  if(status === "success") {
    page.render('example.png');
  }

  page.evaluate(function() {
    console.log(document.name);
  });
  console.log(page.plainText);

  phantom.exit();
});
