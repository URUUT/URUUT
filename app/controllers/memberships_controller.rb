class MembershipsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_membership, only: [:show, :update, :edit]

  def update
    plan = Plan.where(name: params[:membership_type]).first
    @membership.plan = plan

    if @membership.save
      flash[:notice] = 'You have not been subscribed.'
      redirect_to user_membership_path(current_user, @membership)
    else
      flash[:alert] = 'You have not been subscribed.'
      redirect_to pricing_page_pages_path()
    end
  end

  def cancel
  end

  def destroy
    plan_service = Gateway::PlansService.new(current_user)

    respond_to do |format|
      if plan_service.cancel_plan && current_user.finish_ongoing_projects
        format.json { render json: root_path }
      else
        format.json { render json: { message: 'Something was wrong.' }, status: 500 }
      end
    end
  end

  private

  def find_membership
    @membership = current_user.membership
  end
end
