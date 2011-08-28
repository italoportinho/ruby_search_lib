require 'rubygems'
require 'mechanize'
require_relative 'serp_item'
require_relative 'yahoo_serp_scraper'
require_relative 'google_serp_scraper'
require_relative 'bing_serp_scraper'

class Serp
  attr_reader :scraper

  def initialize(searchEngine,keyword,max_results)
    case searchEngine
      when /yahoo/ then  @scraper = YahooSerpScraper.new(keyword,max_results)
      when /bing/ then @scraper = BingSerpScraper.new(keyword,max_results)
      else @scraper = GoogleSerpScraper.new(keyword,max_results)
    end

  end

  def to_s
    "#{@scraper}"
  end
end