require 'crawler'
require 'quotes_cache_handler'
require 'tag_handler'

class QuotesManager 
  def getQuotes(search_tag) 
    @crawler = Crawler.new
    @quotes_cache_handler = QuotesCacheHandler.new
    @tag_handler = TagHandler.new
    if(!@tag_handler.wasAlreadySearched?(search_tag))
      @quotes = @crawler.getQuotesFromDocument(search_tag)
      @quotes_cache_handler.saveQuotes(@quotes)
      @tag_handler.saveTag(search_tag)
    else
      @quotes = @quotes_cache_handler.getQuotesFromDatabase(search_tag)
    end
    return @quotes
  end
end