require 'spec_helper'

describe Problem do
	it 'is vallid duplicate problem' do
		problem = Problem.first
		duplicate_problem = problem.duplicate
		expect(duplicate_problem).to be_valid
	end

end
