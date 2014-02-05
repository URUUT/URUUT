class MarketingInfosController < ApplicationController

  def create
    @marketing_info = MarketingInfo.new(first_name: params[:marketing_info][:first_name], last_name: params[:marketing_info][:last_name], email: params[:marketing_info][:email])
    if @marketing_info.save
      url = params[:marketing_info][:href]
      url << "&marketing_info_id=#{@marketing_info.id}"
      redirect_to url
    else
      redirect_to choose_plan_pages_path, notice: 'Email error'
    end
  end

end