class DemoRequestsController < ApplicationController

  def new
    @demo = Demo.new
  end

  def create
    @demo = Demo.new(params[:demo])
  end
end