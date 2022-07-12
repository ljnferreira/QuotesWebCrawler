require 'open-uri'

=begin
  Esta classe é a responsável por fornecer um metodo que faz a busca pelas quotes
no site e as filtra acordo com a tag pesquisada e retorna uma lista(Array) com as
frases e os dados relacionados à elas. 
=end
class Crawler 
  
  #Percorre as paginas do site, extraindo as frases e retorna um array com as 
  #frases que contem a tag pesquisada. 
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
        quotesArray.push(quoteData) if quoteData[:tags].include?(tag)
      end

      @url = get_link(_next) unless _next.empty?
      break if (_next.empty?)
    end
    return quotesArray
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

end