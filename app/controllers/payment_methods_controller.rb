class PaymentMethodsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_customer_data
  before_filter :new_credit_card, only: [:new, :edit]

  def new
    customer_plan = Gateway::PlansService.new(current_user)
    plan_id = params[:plan_id]
    @plan = Plan.where("name = ?", plan_id).first
    if plan_id == 'fee'
      customer_plan.update_plan('fee')
      redirect_to users_sign_up_confirmation_path
    end
  end

  def edit
  end

  def create
    @credit_card = CreditCard.new(params[:credit_card])
    customer_plan = Gateway::PlansService.new(current_user)
    plan_id = params[:credit_card][:plan_id]
    coupon = Gateway::CouponService.new(current_user)
    coupon.removeInvalid if current_user.coupon_stripe_token
    begin
      if @credit_card.valid? && @card_service.create(@credit_card) &&
         coupon.create(params[:coupon])
        customer_plan.update_plan(plan_id) if plan_id.present?
        current_user.send_welcome_email
        redirect_to users_sign_up_confirmation_path
      else
        render :new
      end
    rescue Stripe::CardError => e
      @credit_card.errors.add(:base, e.message)
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
