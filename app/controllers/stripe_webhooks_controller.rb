class StripeWebhooksController < ApplicationController
  def index
    event = JSON.parse(request.body.read)
    event_type = event['type']
    if event_type == 'charge.succeeded'
      card = event['data']['object']['card']
      cust_token = card['customer']

      customer = Stripe::Customer.retrieve('cus_3xcg13QymqmYQl')

      ActionMailer::Base.mail(from: 'cbartels@uruut.com', to: customer['email'], subject: 'Successful Charge', body: 'webhook testy test').deliver
    end
    render :nothing => true
  end
end