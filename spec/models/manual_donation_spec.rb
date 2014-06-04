require "spec_helper"

describe ManualDonation do
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:amount) }
end
