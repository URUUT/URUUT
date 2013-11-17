require 'spec_helper'

describe SponsorshipBenefit do
	
	it { should respond_to(:name) }
	it { should respond_to(:sponsorship_level_id) } 
	it { should respond_to(:project_id, :status) }
	it { should respond_to(:cost) }
end