require_relative '../lib/serp.rb'

serp = Serp.new("bing","seo",10)
serp.scraper.goToPage(2)
p serp.scraper


