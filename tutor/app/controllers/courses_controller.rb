class CoursesController < ApplicationController

	# Description: This action renders a list of all courses belonging to 
	# 			   the current user.
	# Parameters:
	#	current_lecturer: The current signed in lecturer
	# Returns: 
	# 	@course: A list of all the lecurer's courses
	# Author: Ahmed Osam
	def index
		@courses = current_lecturer.courses.order("created_at desc")
	end  

	# Description: This action takes the course id, remove it from the database
	# 			   and then redirects the user to the show courses page accompanied
	# 			   with a "Course deleted" message.
	# Parameters:
	#	params[:id]: The current course's id
	# Returns: 
	# 	none
	# Author: Mohamed Metawaa
	def destroy
		course = Course.find_by_id(params[:id])
		course.destroy
		flash[:success] = "Course deleted."
		redirect_to :action => 'index'
	end

	# Description: This action creates a new instance variable for the course
	# Parameters:
	#	none
	# Returns: 
	# 	@new_course: A new course instance 
	# Author: Mohamed Mamdouh
	def new
		if(@new_course == nil)
			@new_course = Course.new
		end
	end

	# Description: This action takes the info submited by the user in the form 
	# 			   and creates a new record. Then, insert it in the table. If the 
	# 			   insertion did not succeed, and error message will appear
	# Parameters:
	#	none
	# Returns: 
	# 	none
	# Author: Mohamed Mamdouh
	def create
		@new_course  = Course.new
		@new_course.name = course_params[:name]
		@new_course.code = course_params[:code]
		@new_course.year = course_params[:year]
		@new_course.semester = course_params[:semester]
		@new_course.description = course_params[:description]
		if @new_course.save
			current_lecturer.courses << @new_course
			@discussion_board = DiscussionBoard.new
			@discussion_board.title = @new_course.name + " DiscussionBoard"
			@discussion_board.course_id = @new_course.id
			@discussion_board.save
			@new_course.discussion_board = @discussion_board
			flash[:success_creation]= "Course added."
			redirect_to :action => 'index'
		else 
			render :action=>'new'
		end
	end

	# [Action]
	# Description: This action passes and instance variable of the course and its
	# 			   discussionBoard to the edit view
	# Parameters:
	#	params[:id]: The current course's id
	# Returns: 
	# 	@course
	# 	@discussionBoard
	# Author: Mohamed Mamdouh
	def edit
		@course = Course.find_by_id(params[:id])
		@discussionBoard = @course.discussion_board
	end

	# Description: This action shows a specific selected course.
	# Parameters:
	#	params[:id]: The current course's id
	# Returns: 
	# 	none
	# Author: Ahmed Osam
	def show
		@course = Course.find_by_id(params[:id])
	end

	def manage
	end

	private 
		def course_params 
			params.require(:course).permit(:name,:code,:year,:semester,:description)
		end
		
end