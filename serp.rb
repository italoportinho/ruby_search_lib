require 'rubygems'
require 'mechanize'
require_relative 'serp_item'

class Serp
  attr_reader  :searchEngine, :keyword, :total_results, :current_page

  def initialize(searchEngine,keyword,max_results)
    case searchEngine
      when /yahoo/ then  @search_engine = "http://br.search.yahoo.com/search?p=#{keyword}&n=#{max_results}" #max = 100
      when /bing/ then @search_engine = "http://br.bing.com/search?q=#{keyword}&go=&filt=all&count=#{max_results}" #max=59
      else @search_engine = "http://www.google.com.br/search?q=#{keyword}&num=#{max_results}"  #max=100
    end
    @searchEngine = searchEngine
    @keyword = keyword
    @max_results  = max_results
    @total_results = -1
    @current_page = -1
    @links = {}
    @search_results = nil

    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Mozilla'
    @search_results = agent.get(@search_engine)
=begin
    search_form = web_page.form_with(:name => "f")
    search_form.field_with(:name => "q").value = @keyword
    @search_results = agent.submit(search_form)
=end

    @total_results = self.parseTotalResults(@search_results)
    @current_page = 1
    self.updateLinks()
  end

  def parseTotalResults(page)
    case searchEngine
      when "google" then return  page.parser.css('#resultStats').text.to_s.scan((/(\d+\.\d+.\d+)+/)).to_s.gsub(/\[+|\]+|"/,'')
      when "bing" then return page.parser.css('#count').text.to_s.scan((/(\d+\.\d+.\d+)+/)).to_s.gsub(/\[+|\]+|"/,'')
      when "yahoo" then return page.parser.css('#resultCount').text.to_s.scan((/(\d+\.\d+.\d+)+/)).to_s.gsub(/\[+|\]+|"/,'')
    end
  end

  def updateLinks()
    rank = 0
    num = 0
    case searchEngine
      when "google" then
        @search_results.links().each do |link|
        cls = link.attributes.attributes['class']
          if cls && cls.value == 'l' then
            rank = num + 1 + (@current_page - 1)*10
            num = num + 1
            title = link.text
            url = link.href
            snippet = '' #a implementar
            serp_item = SerpItem.new(title,url,rank,snippet)
            @links[rank] = serp_item
          end
        end

      when "yahoo" then
        @search_results.links().each do |link|
          cls = link.attributes.attributes['class']
          if cls && cls.value == 'yschttl spt' then
            rank = num + 1 + (@current_page - 1)*10
            num = num + 1
            title = link.text
            url = link.href.to_s.scan(/http%3a.*/)
            snippet = '' #a implementar
            serp_item = SerpItem.new(title,url,rank,snippet)
            @links[rank] = serp_item
          end
        end

      when "bing" then
        tag = @search_results.parser.css('div.sb_tlst')
        tag.each do |node|
          node.children.children.each do |child|
            if !(child.attr('href') =~ /microsofttranslator/) then
              #p child
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
  end

  def goToPage(num)
     @search_results.links().each do |link|
       if link.text().eql?num.to_s  then
         @search_results = link.click()
         @current_page = num
         self.updateLinks()
       end
     end
  end

  def to_s
    "
    searchEngine: #{@searchEngine} \n
    keyword: #{@keyword} \n
    total_results: #{@total_results} \n
    current_page: #{@current_page} \n
    links: #{@links} \n"
  end
end