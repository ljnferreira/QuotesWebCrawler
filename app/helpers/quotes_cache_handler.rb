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
  
  def getQuotesFromDatabaseByTag(tag)
    @quotes = Quote.where(:tags.in => [tag])
    return filter_quotes_atributes(@quotes)
  end
  
  def getAllQuotesFromDatabase
    @quotes = Quote.all
    return filter_quotes_atributes(@quotes)
  end

  def cleanQuotesCache 
    return Quote.delete_all
  end

  private

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