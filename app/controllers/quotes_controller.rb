require 'quotes_manager'

class QuotesController < ApplicationController
  before_action :authenticate_user,  only: [:tag]
  
  def tag
    @quotes_manager = QuotesManager.new

    @tag = quotes_params
    @quotes = @quotes_manager.getQuotes(@tag)
    render json: {:quotes => @quotes}
  end

  private

  def quotes_params
    params.require(:search_tag)
  end

end
