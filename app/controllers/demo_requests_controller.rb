class DemoRequestsController < ApplicationController
  layout "landing", only: [:thank_you]

  def new
    @demo = Demo.new
  end

  def create
    @demo = Demo.new(params[:demo])
  end

  def thank_you
    
  end
end