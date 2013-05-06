ActiveMerchant::Billing::Base.mode = :test
GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
  :login => "seller_1229899173_biz_api1.railscasts.com",
  :password => "FXWU58S7KXFC6HBE",
  :signature => "AGjv6SW.mTiKxtkm6L9DcSUCUgePAUDQ3L-kTdszkPG8mRfjaRZDYtSu"
)