class Sponsors::DashboardController < ApplicationController
  before_filter :authenticate_sponsor!
  def index
  end
end
