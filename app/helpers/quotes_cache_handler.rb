class QuotesCacheHandler 
  def saveQuotes(quotes)
    quotes.each do |quote|
      _already_exists = Quote.where(:quote => quote[:quote]).exists?
      if(not _already_exists)
        _q = Quote.new(quote)
        _q.save
      end
    end
  end
  
  def getQuotesFromDatabase(tag)
    @quotes = Quote.all
    @quotes = filter_quotes_by_tag(@quotes, tag)
    @quotes = filter_quotes_atributes(@quotes)
    return @quotes
  end

  private

  def filter_quotes_by_tag(quotes, search_tag)
    quotes_with_tag = []
    quotes.each do |quote|
      quote[:tags].each do |tag|
        quotes_with_tag.push(quote) if search_tag == tag
      end
    end
    quotes = quotes_with_tag
    return quotes
  end

  def filter_quotes_atributes(quotes)
    filtered_quotes = []
    quotes.each do |quote|
      filtered_quotes.push(filter_quote_atributes(quote))
    end
    return filtered_quotes
  end

  def filter_quote_atributes(quote)
    return quote.attributes.slice(
      'author', 'author_about', 'quote', 'tags'
    )
  end
end