class DemoRequestsController < ApplicationController
  layout "landing", only: [:thank_you]
  before_filter :set_demo, only: [:new, :organization]

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

  def organization
  end

  def thank_you
  end

  protected

  def set_demo
    @demo = Demo.new
  end
end