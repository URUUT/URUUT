class DemoRequestsController < ApplicationController
  layout "landing", only: [:thank_you]

  def new
    @demo = Demo.new
  end

  def create
    @demo = Demo.new(params[:demo])

    if @demo.save
      redirect_to thank_you_demo_request_path
    else
      render :new
    end
  end

  def thank_you
    
  end
end