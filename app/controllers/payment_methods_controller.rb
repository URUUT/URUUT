class PaymentMethodsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_customer_data, only: [:edit, :update]

  def edit
    @credit_card = CreditCard.new()
    @customer_card = @card_service.find_card
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

  def find_customer_data
    @card_service = Gateway::CardsService.new(current_user)
    @customer = @card_service.find_customer
  end

end
