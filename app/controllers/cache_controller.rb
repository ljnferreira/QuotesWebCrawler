class CacheController < ApplicationController
  before_action :authenticate_user,  only: [:saved_quotes, :clean_cache, :searched_tags]
  before_action :authorize_as_admin, only: [:saved_quotes, :clean_cache, :searched_tags]

  def saved_quotes
    @quotes = Quote.all
    @quotes = filter_quotes_atributes(@quotes)

    render json: {cached_quotes: @quotes}
  end

  def searched_tags
    @tags = UsedTag.all
    @tags = filter_tags(@tags)
    render json: {searched_tags: @tags}
  end

  def clean_cache
    @tags = UsedTag.delete_all
    @quotes = Quote.delete_all

    render json: {tags_deleted: @tags, quotes_deleted: @quotes}
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
      'author', 'quote', 'tags'
    )
  end

  def filter_tags(tags)
    filtered = []
    tags.each do |tag|
      filtered.push(tag.attributes.slice('tag'))
    end
    return filtered unless filtered.empty?
  end
end
