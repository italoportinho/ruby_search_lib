require 'rubygems'
require 'mechanize'
require_relative 'serp_item'
require_relative 'generic_serp_scraper'

class BingSerpScraper  < GenericSerpScraper
  attr_accessor :engine,:keyword,:max_results,:url,:search_results,:total_results,:current_page,:links

  MAX = 59

    def initialize(keyword,max_results)
    @engine = 'bing'
    @keyword =  keyword
    if max_results <= MAX then @max_results = max_results end
    @url = "http://br.bing.com/search?q=#{@keyword}&go=&filt=all&count=#{@max_results}"

    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Mozilla'
    @search_results = agent.get(@url)
    @links = {}
    parseTotalResults('#count')
    @current_page = 1
    updateLinks()
  end

  def updateLinks()
    rank = 0
    num = 0
    tag = @search_results.parser.css('div.sb_tlst')
    tag.each do |node|
      node.children.children.each do |child|
        if !(child.attr('href') =~ /microsofttranslator/) && rank <= @max_results*@current_page then
          rank = num + 1 + (@current_page - 1)*10
          num = num + 1
          title = child.text()
          url = child.attr('href')
          snippet = '' #a implementar
          serp_item = SerpItem.new(title,url,rank,snippet)
          @links[rank] = serp_item
        end
      end
    end
  end

  def goToPage(num)
     @search_results.links().each do |link|
       if link.text().eql?num.to_s  then
         @search_results = link.click()
         @current_page = num
         @links = {}
         self.updateLinks()
       end
     end
  end

end