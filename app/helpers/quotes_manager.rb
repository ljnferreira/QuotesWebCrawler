require 'crawler'
require 'quotes_cache_handler'

class QuotesManager 
  def getQuotes(search_tag) 
    @crawler = Crawler.new
    @quotes_cache_handler = QuotesCacheHandler.new
    used_tag = UsedTag.where(tag: search_tag).first
    if(used_tag.nil?)
      @quotes = @crawler.getQuotesFromDocument(search_tag)
      @quotes_cache_handler.saveQuotes(@quotes)
      used_tag = UsedTag.new(tag: search_tag)
      used_tag.save
    else
      @quotes = @quotes_cache_handler.getQuotesFromDatabase(search_tag)
    end
    return @quotes
  end
end