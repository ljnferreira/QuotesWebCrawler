require 'quotes_cache_handler'
require 'tag_handler'

class CacheController < ApplicationController
  before_action :authenticate_user,  only: [:saved_quotes, :clean_cache, :searched_tags]
  before_action :authorize_as_admin, only: [:saved_quotes, :clean_cache, :searched_tags]

  def saved_quotes
    @quotes_cache_handler = QuotesCacheHandler.new
    @quotes = @quotes_cache_handler.getQuotesFromDatabase(nil)

    render json: {cached_quotes: @quotes}
  end

  def searched_tags
    @tag_handler = TagHandler.new
    @tags = @tag_handler.getTags
    
    render json: {searched_tags: @tags}
  end

  def clean_cache
    @quotes_cache_handler = QuotesCacheHandler.new
    @tag_handler = TagHandler.new
    
    @tags = @tag_handler.cleanTags
    @quotes = @quotes_cache_handler.cleanQuotesCache

    render json: {tags_deleted: @tags, quotes_deleted: @quotes}
  end
end
