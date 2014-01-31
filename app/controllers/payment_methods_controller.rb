class PaymentMethodsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_customer_data
  before_filter :new_credit_card, only: [:new, :edit]

  def new
  end

  def edit
  end

  def create
    @credit_card = CreditCard.new(params[:credit_card])
    customer_plan = Gateway::PlansService.new(current_user)
    plan_id = params[:credit_card][:plan_id]

    if @credit_card.valid? && @card_service.create(@credit_card)
      customer_plan.update_plan(plan_id) if plan_id.present?
      redirect_to new_project_path
    else
      render :new
    end
  end

  def update
    credit_card = CreditCard.new(params[:credit_card])

    if @card_service.create(credit_card)
      flash[:notice] = 'Payment method updated.'
    else
      flash[:notice] = 'Something went wrong. Please try again in a few minutes.'
    end

    redirect_to edit_user_payment_method_path(current_user)
  end

private

  def new_credit_card
    @credit_card = CreditCard.new()
    @customer_card = @card_service.find_card
  end

  def find_customer_data
    @card_service = Gateway::CardsService.new(current_user)
    @customer = @card_service.find_customer
  end

end
