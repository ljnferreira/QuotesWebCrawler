require 'crawler'
require 'quotes_cache_handler'
require 'tag_handler'
=begin
  Esta classe efetua o gerenciamento das Quotes obtidas através de 2 metodos,
  getQuotes e update quotes.
=end
class QuotesManager 
=begin
  Este metodo efetua a busca pelas Quotes seja no banco de cache ou diretamente
  no site onde se localizam, a depender se uma tag já foi buscada ou não, e em 
  caso de já ter sido buscada mas não haverem Quotes no banco de dados atreladas
  a ela executa nova busca no site.
=end
  def getQuotes(search_tag) 
    @crawler = Crawler.new
    @quotes_cache_handler = QuotesCacheHandler.new
    @tag_handler = TagHandler.new
    if(!@tag_handler.wasAlreadySearched?(search_tag))
      @quotes = @crawler.getQuotesFromDocument(search_tag)
      if (@quotes.empty?)
        @quotes_cache_handler.saveQuotes(@quotes)
      end
      @tag_handler.saveTag(search_tag)
    else
      @quotes = @quotes_cache_handler.getQuotesFromDatabaseByTag(search_tag)
      if(@quotes.empty?)
        @quotes = @crawler.getQuotesFromDocument(search_tag)
        if (@quotes.empty?)
          @quotes_cache_handler.saveQuotes(@quotes)
        end
      end
    end
    return @quotes
  end
=begin
  Este método efetua a atualização do cache de Quotes salvas, buscando para cada
  tag já buscada as repectivas quotes atreladas à ela, atualizando as necessárias.
=end
  def updateQuotes
    @tag_handler = TagHandler.new
    @crawler = Crawler.new
    @quotes_cache_handler = QuotesCacheHandler.new
    _tags = @tag_handler.getTags
    _tags.each do |tag| 
      _quotes = @crawler.getQuotesFromDocument(tag[:tag])
      @quotes_cache_handler.saveQuotes(_quotes)
    end
  end
end