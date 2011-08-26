require 'rubygems'
require 'mechanize'
require_relative 'serp_item'
require_relative 'generic_serp_scraper'

class YahooSerpScraper < GenericSerpScraper
  attr_accessor :engine,:keyword,:max_results,:url,:search_results,:total_results,:current_page,:links

  MAX = 100

  def initialize(keyword,max_results)
    @engine = 'yahoo'
    @keyword =  keyword
    @class_value = 'yschttl spt'
    @href_pattern = 'http%3a.*'
    if max_results <= MAX then @max_results = max_results end
    @url = "http://br.search.yahoo.com/search?p=#{@keyword}&n=#{@max_results}"

    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Mozilla'
    @search_results = agent.get(@url)
    @links = {}
    parseTotalResults('#resultCount')
    @current_page = 1
    updateLinks(@class_value,@href_pattern)
  end
end