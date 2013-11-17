require 'spec_helper'

describe Sponsor do

	it { should respond_to(:email) } 
	it { should respond_to(:name) } 
	it { should respond_to(:payment_type) }

end