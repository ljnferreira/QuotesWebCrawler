require 'sidekiq'
require 'quotes_manager'

class UpdateJob < ActiveJob::Base
  def perform
    @quotes_manager = QuotesManager.new
    @quotes_manager.updateQuotes
  end
end