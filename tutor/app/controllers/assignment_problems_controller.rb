class AssignmentProblemsController < ApplicationController
 def new
  	session[:assignment_id] = params[:id]
  	@assignment =Assignment.find_by_id(session[:assignment_id])
  
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
				redirect_to :controller => 'assignment_problems', :action => 'new',
			 		:id => @assignment.id
			else
				flash.keep[:notice] = "Problem is missing paramaters"
				redirect_to :back
			end
		
  end

	def complete
		@assignment =Assignment.find_by_id(session[:assignment_id])
   
       @sproblems = Array.new

       params[:checkbox].each do |check|
       	@problem_select =Problem.find_by_id(check)
       	@new_problem = AssignmentProblem.new
       	@new_problem.title = @problem_select.title
       	@new_problem.description = @problem_select.description
       	@new_problem.assignment_id = @assignment.id
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
				
			
			end

       puts "=====00000000000========================="
       puts check
       puts "===========0000000000000000000000000000000000"

 	end
  redirect_to :controller => 'assignment_problems', :action => 'show',
			 		:id => @assignment.id
end

  	

  def edit
  end

  def show
  	@assignment_p = Assignment.find_by_id(session[:assignment_id])
  	@problems_complete = AssignmentProblem.where("assignment_id = ?", session[:assignment_id])

  		@grades.each do |grade|

       puts "=====00000000000========================="
       puts grade
       puts "===========0000000000000000000000000000000000"
            		 
          		end


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
     @problems =Array.new
      if !@tracks.empty?
        @tracks.each do |track| 
        	@probs = track.problems
          		@probs.each do |problem1|
            		@problems.push(problem1)  
          		end
  			end
    	end
    @contest = @course.contests
    @cproblems = Array.new
    @contest.each do |contest| 
        @cprob = contest.problems
        @cprobs.each do |problem1|
            @cproblems.push(problem1)  
        end
  	end
  
end

  private
		def problem_params
			params.require(:assignment_problem).permit(:title, :description, :final_grade)
		end

end
