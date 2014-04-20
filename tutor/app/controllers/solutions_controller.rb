class SolutionsController < ApplicationController

	# [Code Editor: Write Code - Story 3.3]
	# submits a solution for a problem that the student chose
	# and show an alert box  for success and failure scenarios 
	# Parameters: 
	# 	solution_params: submitted from the form_for
	# Returns: none
	# Author: MOHAMEDSAEED
	def create
		@solution = Solution.new(solution_params)
		@solution.student_id = current_student.id
		@solution.status = 0
		@solution.length = @solution.code.length
		respond_to do |format|
			format.html { redirect_to :back }
			format.js { render 'alert.js.erb' }
		end
	end

	# [Code Editor: Write Code - Story 3.3]
	# Fills the ID of the problem , code from the form_for 
	# Parameters:
	# 	code: The written code for the problem
	# 	problem_id: Hidden field for problem id
	# Returns: none
	# Author: MOHAMEDSAEED
	private
	def solution_params
		params.require(:solution).permit(:code , :problem_id)
	end
	
end