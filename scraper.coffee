# Import Libraries
request = require "request-promise"
Promise = require "bluebird"
fs      = require "fs"

# Scraper Class
class Scraper
	
	# Private Variables
	_endpoint: "https://api.justwatch.com"


	# Private Methods
	_popular: (locale)->	
		page_size = 200
		item_count = 1000
		items_list = []
		
		Promise.each [0...(item_count/page_size)], (i)=>		
			i += 1
			console.log "* Downloading titles #{page_size * i}/#{item_count}"
			
			return request
				uri: "#{@_endpoint}/titles/#{locale}/popular"
				method: 'POST'
				gzip: true
				json: true
				body:
					content_types: [ "show", "movie" ]
					page: i
					page_size: page_size
			
			.then (data)-> 
				items_list = items_list.concat data.items
		
		.then -> return items_list
			
	_show: (id, locale)->
		console.log "* Downloading show data for ID: ##{id}"
		
		url = "#{@_endpoint}/titles/show/#{id}/locale/#{locale}"
	
		return request.get 
			uri: url
			json: true


	# Public Methods
	scrape: (locale)->
		if not locale?
			locale = "en_US"
	
		@_popular(locale).then (titles)=>
			return Promise.all titles.map (title)=>
				data = {
					title: title.title
					year: title.original_release_year
					type: title.object_type
				}
				
				if data.type == "movie"
					return data
					
				return @_show(title.id, locale).then (show)->
					data.season_count = show.seasons.length
					return data
					
		.then (titles)->
			return {
				titles: titles
				title_count: titles.length
				locale: locale
			}
			

# Make Module Exportable
module.exports = Scraper
			

# Initialize
# --------------------------------
# Scrape JustWatch.com and save
# output to text file if called 
# from command line
if require.main == module
	scraper = new Scraper()
	
	scraper.scrape(process.argv[2]).then (response)->
		filePath = "#{__dirname}/output.txt"
		data = JSON.stringify response
	
		fs.writeFile filePath, data, ->
			console.log "* File saved to #{filePath}"
