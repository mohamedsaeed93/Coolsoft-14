class SolutionsConstraintsController < ApplicationController
	# [Edit Solutions' Constraints - Story 4.14]
	# Display all the parameters and the names of the method and the variables
	# Parameters: 
	#   Parameter: null
	# Returns: 
	# 	@parameters: A list of all the methods parameters
	# 	@variables: A list of all the variables constraints
	# 	@methods: A list of all the methods constraints
	# Author: Rania Abdel Fattah
	def index
		@parameters = MethodParameter.all
		@variables = VariableConstraint.all 
		@methods = MethodConstraint.all 
	end

	# [Edit Solutions' Constraints - Story 4.14]
	# Display only one record for the method parameter and the variable constraint and
	# the method constraint
	# Parameters: 
	#   params[:id]: The method parameter and the variable constraint and the method variable
	# Returns: null
	# Author: Rania Abdel Fattah
	def show
		@parameters = MethodParameter.find_by_id(params[:id])
		@variables = VariableConstraint.find_by_id(params[:id])
		@methods = MethodConstraint.find_by_id(params[:id])
		if @parameters.nil?
			redirect_to :action => 'index'
		end
	end

	# [Edit Solutions' Constraints - Story 4.14]
	# Display only one record for the method parameter and the variable constraint and
	# the method constraint
	# Parameters: 
	#   params[:id]: The method parameter and the variable constraint and the method variable
	# Returns: null
	# Author: Rania Abdel Fattah
	def edit
		if lecturer_signed_in? || teaching_assistant_signed_in?
			@parameters = MethodParameter.find_by_id(params[:id])
			@variables = VariableConstraint.find_by_id(params[:id])
			@methods = MethodConstraint.find_by_id(params[:id])	
		end
	end

	# [Edit Solutions' Constraints - Story 4.14]
	# Brief description of method
	# Parameters: 
	#   Parameter: description
	# Returns: in case of success or failure
	# =>  Author: Your Name
	def update
		@parameters = MethodParameter.find_by_id(params[:id])
		@variables = VariableConstraint.find_by_id(params[:id])
		@methods = MethodConstraint.find_by_id(params[:id])
		if  @parameters && @variables && @methods
				@parameters.parameter = constraint_params[:parameters] 
				@variables.variable_name = constraint_params[:variables] 
				@methods.method_name = constraint_params[:methods]
				@parameters.save
				@variables.save
				@methods.save
				flash[:notice] = "Constraints updated"
				redirect_to :action => 'show'
		else
			redirect_to :action => 'index'
		end
	end

	# [Edit Solutions' Constraints - Story 4.14]
	# Brief description of method
	# Parameters: 
	#   Parameter: description
	# Returns: in case of success or failure
	# Author: Your Name
	private
	def constraint_params
		params.require(:parameter).permit(:parameters, :variables, :methods)
	end
end