require 'open-uri'

class Crawler 
  def getQuotesFromDocument(tag)
    @url = 'http://quotes.toscrape.com/'
    quotesArray = Array.new
    loop do
      doc = get_document(@url)
      docQuotes = doc.css('.quote')
      _next = doc.css('.next a')
      
      docQuotes.each do |quote|
        quoteData = Hash.new
        quoteData[:author] = quote.css('.author').inner_text
        quoteData[:author_about] = get_link(quote.css('span a'))
        quoteData[:quote] = get_quote_text(quote.css('.text'))
        quoteData[:tags] = get_tags(quote.css('.tag'))
        quotesArray.push(quoteData)
      end

      @url = get_link(_next) unless _next.empty?
      break if (_next.empty?)
    end
    quotes = filter_quotes_by_tag(quotesArray, tag)
    return quotes
  end
  
  private

  def get_document(url)
    fh = URI.open(url)
    html = fh.read
    doc = Nokogiri.HTML5(html)
    return doc
  end

  def get_tags(doc_tags)
    tags = []
    doc_tags.each do |t|
      tags.push(t.inner_text)
    end
    return tags
  end

  def get_link(doc_a)
    partial = doc_a.map { |a| a['href']}
    link = "http://quotes.toscrape.com#{partial[0]}" 
    return link
  end

  def get_quote_text(doc_quote)
    return doc_quote.inner_text.sub(/[\”]/,'').sub(/[\“]/,'')
  end

  def filter_quotes_by_tag(quotes, search_tag)
    quotes_with_tag = []
    quotes.each do |quote|
      quote[:tags].each do |tag|
        quotes_with_tag.push(quote) if tag.eql?(search_tag)
      end
    end
    puts "filtered_quotes #{quotes_with_tag}"
    quotes = quotes_with_tag
    return quotes
  end

end