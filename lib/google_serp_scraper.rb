require 'rubygems'
require 'mechanize'
require_relative 'serp_item'
require_relative 'generic_serp_scraper'

class GoogleSerpScraper < GenericSerpScraper
  attr_accessor :engine,:keyword,:max_results,:url,:search_results,:total_results,:current_page,:links

  MAX = 100

    def initialize(keyword,max_results)
    @engine = 'google'
    @keyword =  keyword
    @class_value = 'l'
    if max_results <= MAX then @max_results = max_results end
    @url = "http://www.google.com.br/search?q=#{@keyword}&num=#{@max_results}"

    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Mozilla'
    @search_results = agent.get(@url)
    @links = {}
    parseTotalResults('#resultStats')
    @current_page = 1
    updateLinks(@class_value)
  end

end