class MembershipsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_membership, only: [:show, :edit]

  def create
    user_membership = current_user.membership
    user_membership.kind = params[:membership_type]

    if user_membership.save
      flash[:notice] = 'You have not been subscribed.'
      redirect_to user_membership_path(current_user, user_membership)
    else
      flash[:alert] = 'You have not been subscribed.'
      redirect_to pricing_page_pages_path()
    end
  end

  def show
  end

  def edit
  end

  private

  def find_membership
    @membership = current_user.membership
  end
end
