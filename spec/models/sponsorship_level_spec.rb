require 'spec_helper'

describe SponsorshipLevel do

	it { should respond_to(:name) }
	it { should respond_to(:cost) } 
	it { should respond_to(:description) } 
	it { should respond_to(:required) } 
	it { should respond_to(:funding_goal) } 
end