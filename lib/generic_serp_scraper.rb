class GenericSerpScraper
  @engine = ''
  @url = ''
  @max_results = 10
  @total_results = -1
  @current_page = -1
  @links = {}
  @search_results = nil


  def updateLinks(class_value,*href_pattern)
    rank = 0
    num = 0
    @search_results.links().each do |link|
      cls = link.attributes.attributes['class']
      if cls && cls.value == class_value && rank <= @max_results*@current_page then
        rank = num + 1 + (@current_page - 1)*10
        num = num + 1
        title = link.text
        if href_pattern.length == 0 then
          url = link.href
        else url = link.href.to_s.scan(/#{href_pattern[0]}/)
        end
        snippet = '' #a implementar
        serp_item = SerpItem.new(title,url,rank,snippet)
        @links[rank] = serp_item
      end
    end
  end

  def goToPage(num)
    @search_results.links().each do |link|
       if link.text().eql?num.to_s  then
         @search_results = link.click()
         @current_page = num
         @links = {}
         if self.instance_of?GoogleSerpScraper then self.updateLinks(@class_value)
           else if self.instance_of?YahooSerpScraper then self.updateLinks(@class_value,@href_pattern)end
         end
       end
    end
  end

  def parseTotalResults(selector)
    @total_results = @search_results.parser.css(selector).text.to_s.scan((/(\d+\.\d+.\d+)+/)).to_s.gsub(/\[+|\]+|"/,'')
  end

  def to_s
    "
    searchEngine: #{@engine} \n
    keyword: #{@keyword} \n
    total_results: #{@total_results} \n
    current_page: #{@current_page} \n
    links: #{@links} \n"
  end

end