class MarketingInfosController < ApplicationController

  def create
    @marketing_info = MarketingInfo.new(first_name: params[:marketing_info][:first_name], last_name: params[:marketing_info][:last_name], email: params[:marketing_info][:email])
    if @marketing_info.save
      redirect_to params[:marketing_info][:href]
    else
      redirect_to choose_plan_pages_path
    end
  end

end