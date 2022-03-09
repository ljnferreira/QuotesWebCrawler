require 'open-uri'

class QuotesController < ApplicationController
  def index
    @quotes = Quote.all
    render json: {saved: @quotes, all: get_quotes_from_document}
  end

  def tag
    @tag = quotes_params
    used_tag = UsedTag.where(tag: @tag).first
    if(used_tag.nil?)
      @quotes = get_quotes_from_document
      @quotes = get_quotes_by_tag(@quotes, @tag)
      save_quotes(@quotes)
      used_tag = UsedTag.new(tag: @tag)
      used_tag.save
    else
      @quotes = get_quotes_from_database
      @quotes = get_quotes_by_tag(@quotes, @tag)
      @quotes = filter_quotes_atributes(@quotes)
    end
    render json: {:quotes => @quotes}
  end

  private

  def save_quotes(quotes)
    quotes.each do |quote|
      was_saved = Quote.where(:quote => quote[:quote]).exists?
      if(not was_saved)
        q = Quote.new(quote)
        q.save
      end
    end
  end

  def quotes_params
    params.require(:search_tag)
  end

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

  def get_quotes_from_document
    doc = get_document('http://quotes.toscrape.com/')
    quotes = {}
    quotesArray = []
    docQuotes = doc.css('.quote')
    
    docQuotes.each do |quote|
      quoteData = {}
      quoteData[:author] = quote.css('.author').inner_text
      quoteData[:quote] = quote.css('.text').inner_text
      quoteData[:tags] = get_tags(quote.css('.tag'))
      quotesArray.push(quoteData)
    end
    quotes = quotesArray
    return quotes
  end

  def get_quotes_from_database
    @quotes = Quote.all
    return @quotes
  end

  def get_quotes_by_tag(quotes, search_tag)
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
      'author', 'quote', 'tags'
    )
  end

end
