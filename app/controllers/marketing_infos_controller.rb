class MarketingInfosController < ApplicationController

  def create
    @marketing_info = MarketingInfo.new(params[:marketing_info])
    if @marketing_info.save
      url = @marketing_info.href
      url << "&marketing_info_id=#{@marketing_info.id}"
      redirect_to url
    else
      redirect_to choose_plan_pages_path, notice: 'Email error'
    end
  end

end