class DemoRequestController < ApplicationController
  layout "landing", only: [:thank_you]

  def new
    if current_user
      @demo = Demo.create_for_user(current_user)
      redirect_to demo_request_organization_path(@demo)
    else
      @demo = Demo.new
    end
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
      DemoRequestMailer.scheduled_demo_confirmation(@demo).deliver
      redirect_to demo_request_thank_you_path(@demo)
    else
      render :organization
    end
  end

  def thank_you
  end

  def whitepaper
    DemoRequestMailer.whitepaper_demo_confirmation(@demo).deliver
    send_file 'public/whitepaper.pdf'
  end
end