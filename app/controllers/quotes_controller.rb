require 'open-uri'

class QuotesController < ApplicationController
  def index
    @quotes = Quote.all
    render json: {all: get_quotes, saved: @quotes}
  end

  def tag
    @quotes = get_quotes
    @quotes = get_quotes_by_tag(@quotes, quotes_params)
    quotes = Quote.new(@quotes)
    quotes.save
    render json: {:quotes => @quotes}
  end

  private

  def quotes_params
    params.require(:search_tag)
  end

  def get_document
    url = 'http://quotes.toscrape.com/'
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

  def get_quotes
    doc = get_document
    quotes = {}
    quotesArray = []
    docQuotes = doc.css('.quote')
    
    docQuotes.each do |quote|
      quoteData = {}
      quoteData[:quote] = quote.css('.text').inner_text
      quoteData[:author] = quote.css('.author').inner_text
      quoteData[:tags] = get_tags(quote.css('.tag'))
      quotesArray.push(quoteData)
    end
    quotes[:quotes] = quotesArray
    return quotes
  end

  def get_quotes_by_tag(quotes, search_tag)
    quotes_with_tag = []
    quotes[:quotes].each do |quote|
      quote[:tags].each do |tag|
        quotes_with_tag.push(quote) if search_tag == tag
      end
    end
    quotes[:quotes] = quotes_with_tag
    return quotes
  end

end
