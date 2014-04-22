class SolutionsConstraintsController < ApplicationController
	def index
		@parameters = MethodParameter.all
		@variables = VariableConstraint.all 
		#@methods = MethodConstraints.all 
	end

	def create
		@method_cons = params[:parameter_constraint]
		@var_cons = params[:variable_constraint]
		
		@method = params[:method_name]
		@method_returned = params[:method_return]

		@constarint = MethodConstraint.new
		@Constraint.method_name = @method
		@Constraint.method_return = @method_returned
		@Constraint.save

		redirect_to action:"index"
	end

	def new
		@constrain = MethodConstraint.new
	end

	def show
		@parameters = MethodParameter.find_by_id(params[:id])
		@variables = VariableConstraint.find_by_id(params[:id])
		#@methods = MethodConstraints.find_by_id(params[:id])
		if @parameters.nil?
			redirect_to :action => 'index'
		end
	end

	def edit
		if lecturer_signed_in? || teaching_assistant_signed_in?
			@parameters = MethodParameter.find_by_id(params[:id])
			@variables = VariableConstraint.find_by_id(params[:id])
			#@methods = MethodConstraints.find_by_id(params[:id])	
		end
	end

	def update
		@parameters = MethodParameter.find_by_id(params[:id])
		@variables = VariableConstraint.find_by_id(params[:id])
		if @parameters.update_attributes(constraint_params) && @variables.update_attributes(constraint_params)
			redirect_to :action => 'show'
		else
			redirect_to :action => 'index'
		end
	end

	def delete
		@parameters = MethodParameter.find_by_id(params[:id])
		@variables = VariableConstraint.find_by_id(params[:id])	
	end

	def destroy
		@parameters = MethodParameter.find_by_id(params[:id]).destroy
		@variables = VariableConstraint.find_by_id(params[:id]).destroy
		flash[:success_deletion] = "Constraints deleted."
	end

end
