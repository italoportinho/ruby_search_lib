class SerpItem

  attr_reader :title, :url, :rank, :snippet
  def initialize(title,url,rank,snippet)
    @title = title
    @url = url
    @rank = rank
    @snippet = snippet
  end

  def to_s
    "   \n
        title: #{@title} \n
        url: #{@url} \n
        rank: #{@rank} \n
        snippet: #{@snippet} \n"

  end

end