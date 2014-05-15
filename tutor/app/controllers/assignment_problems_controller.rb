class AssignmentProblemsController < ApplicationController
	def new
		session[:assignment_id] = params[:id]
		@assignment = Assignment.find_by_id(session[:assignment_id])
		@new_problem = AssignmentProblem.new
	
	end

	def create
			@assignment = Assignment.find_by_id(session[:assignment_id])
			@new_problem = AssignmentProblem.new(problem_params)
			@new_problem.final_grade = 0
			if lecturer_signed_in?
				@new_problem.owner_id = current_lecturer.id
				@new_problem.owner_type = "lecturer"
			elsif teaching_assistant_signed_in?
				@new_problem.owner_id = current_teaching_assistant.id
				@new_problem.owner_type = "teaching assistant"
			end
			if @new_problem.save
				@assignment.problems << @new_problem
				flash[:notice] = "problem added."
				redirect_to :controller => 'assignment_problems', :action => 'show',
					:problem_id => @new_problem.id
			else
				render :action=>'new', :assignment_id => session[:assignment_id]
			end	
			rescue
			flash.keep[:notice] = "The track has a problem with the same title"
			redirect_to :back
		
	end

	def complete
		@assignment = Assignment.find_by_id(session[:assignment_id])
	 	@sproblems = Array.new
		params[:checkbox].each do |check|
			@problem_select = Problem.find_by_id(check)
			@new_problem = AssignmentProblem.new
			@new_problem.title = @problem_select.title
			@new_problem.description = @problem_select.description
			@new_problem.assignment_id = @assignment.id
			@new_problem.final_grade = 0
			@new_problem.test_cases = @problem_select.test_cases
			if lecturer_signed_in?
				@new_problem.owner_id = current_lecturer.id
				@new_problem.owner_type = "lecturer"
			elsif teaching_assistant_signed_in?
				@new_problem.owner_id = current_teaching_assistant.id
				@new_problem.owner_type = "teaching assistant"
			end
			if @new_problem.save
				@assignment.problems << @new_problem
			end
		end
		redirect_to :controller => 'assignment_problems', :action => 'index',
			:id => @assignment.id
	end

	def show
		@assignment = Assignment.find_by_id(session[:assignment_id])
		@problem = AssignmentProblem.find_by_id(params[:problem_id])
		@test_case = TestCase.new
	end

	def update 
	end

	def index
		@assignment =Assignment.find_by_id(session[:assignment_id])
		@course_id = @assignment.course_id
		@course = Course.find_by_id(@course_id)
		@topics = @course.topics
		@tracks = Array.new
	 	@problems1 = Array.new
		if !@topics.empty?
			@topics.find_each do |topic|
				@tracksi = topic.tracks
				@tracksi.each do |track|
					@tracks.push(track)	
				end
			end
		end
		@problems = Array.new
		if !@tracks.empty?
			@tracks.each do |track| 
				@probs = track.problems
				@probs.each do |problem1|
					@problems.push(problem1)  
				end
			end
		end
		@bank = Problem.where("seen = ?", true)
		@cproblems = Array.new
		@bank.each do |contest| 
				@cprob = contest.problems
				@cprobs.each do |problem1|
						@cproblems.push(problem1)  
				end
		end
	end

	private
		def problem_params
			params.require(:assignment_problem).permit(:title, :description)
		end

		def p_params
			params.require(:assignment_p).permit(:final_grade)
		end
end