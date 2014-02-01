class DemoRequestController < ApplicationController
  layout "landing", only: [:thank_you]

  def new
    @demo = Demo.new
  end

  def create
    @demo = Demo.new(params[:demo])
    if @demo.save
      redirect_to demo_request_organization_path(@demo)
    else
      render :new
    end
  end

  def edit
    @demo = Demo.find(params[:id])
  end

  def update
    @demo = Demo.find(params[:id])
    if @demo.update_attributes(params[:demo])
      redirect_to demo_request_organization_path(@demo)
    else
      render :edit
    end
  end

  def organization
    @demo = Demo.find(params[:demo_request_id])
  end

  def organization_update
    @demo = Demo.find(params[:demo_request_id])
    if @demo.update_attributes(params[:demo])
      redirect_to demo_request_thank_you_path(@demo)
    else
      render :organization
    end
  end

  def thank_you
  end

  def whitepaper
    send_file 'public/whitepaper.pdf'
  end
end