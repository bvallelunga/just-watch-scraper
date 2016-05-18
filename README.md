# Just Watch Scraper
A scraper for the justwatch.com website that utilizes there
internal APIs. The scraper is capable of localizing the output
data by providing an argument on the `scrape()` method.

To use the scraper:
``` js
var scraper = new Scraper()

scraper.scrape("en_US").then(function(response) {
  console.log(response)
})
```

# API
The Scraper library utilizes the [Bluebird](http://bluebirdjs.com/docs/getting-started.html) 
promise library where all methods will return a promise.

The `scrape(<LOCALE>)` method accepts these locales: 
```
en_US, en_CA, en_MX, pt_BR, de_DE, en_GB, en_IE, 
fr_FR, es_ES, en_NL, en_ZA, en_AU, en_NZ
```
