class CoursesController < ApplicationController

	# [Course Sign-Up - Story 2.6]
	# Allows students to sign-up/register for new courses by choosing
	#	the desired course attributes in the following order:
	#	University > Semester > Course > Instructor > Sign-Up > Confirmation
	# Parameters:
	#	params[]: A hash of the request URL attributes
	# Returns:
	#	@status: The next status (0:Failure:Not a student, 1:University, 2:Semester, 3:Course,
	#		4:Instructor, 5:Sign-Up, 6:Confirmation, 7:Failure:Already signed up)
	#	@courses: A list of the courses
	#	@course: The chosen course
	#	@lecturer: The chosen lecturer
	# Author: Ahmed Moataz
	def sign_up
		@status = params[:status]
		if student_signed_in?
			case params[:status]
			when nil
				@courses = Course.select(:university).distinct
				@status = "1"
			when "2"
				@courses = Course.where("university= " + "\"" + params[:university] +
					"\"").select(:semester).distinct
			when "3"
				@courses = Course.where("semester= " + params[:semester] +
					" AND university = " + "\"" + params[:university] + "\"")
			when "4"
				@course = Course.find(params[:id])
			when "5"
				@course = Course.find(params[:id])
				@lecturer = Lecturer.find(params[:lecturer])
			when "6"
				@course = Course.find(params[:id])
				@lecturer = Lecturer.find(params[:lecturer])
				student = Student.find(current_student.id)
				if student.courses.find_by_id(@course.id) == nil
					student.courses << @course
				else
					@status = "7"
				end
			end
		else
			@status = "0"
		end
	end

	# [View Courses - Stroy 1.11]
	# This action renders a list of all courses belonging to 
	#	the current user.
	# Parameters:
	#	current_lecturer: The current signed in lecturer
	# Returns: 
	#	@course: A list of all the user's courses
	# Author: Ahmed Osam
	def index
		if lecturer_signed_in?
			@courses = current_lecturer.courses.order("created_at desc")
		elsif teaching_assistant_signed_in?
			@courses = current_teaching_assistant.courses.order("created_at desc")
		else
			@courses = current_student.courses.order("created_at desc")
			@share = find_state @courses
		end
	end

	# [Delete a Course - Story 1.12]
	# This action takes the course id, remove it from the database
	#	and then redirects the user to the show courses page accompanied
	#	with a "Course deleted" message.
	# Parameters:
	#	params[:id]: The current course's id
	# Returns: 
	#	none
	# Author: Mohamed Metawaa
	def destroy
		course = Course.find_by_id(params[:id])
		course.destroy
		flash[:success_deletion] = "Course deleted."
		redirect_to :action => 'index'
	end

	# [Define a Course - Story 1.1]
	# Description: This action creates a new instance variable for the course
	# Parameters:
	#	none
	# Returns: 
	#	@new_course: A new course instance 
	# Author: Mohamed Mamdouh
	def new
		if(@new_course == nil)
			@new_course = Course.new
		end
	end

	# [Define a Course - Story 1.1]
	# Description: This action takes the info submited by the user in the form 
	#	and creates a new record. Then, insert it in the table. If the 
	#	insertion did not succeed, and error message will appear
	# Parameters:
	#	none
	# Returns: 
	#	none
	# Author: Mohamed Mamdouh
	def create
		@new_course  = Course.new
		@new_course.name = course_params[:name]
		@new_course.code = course_params[:code]
		@new_course.year = course_params[:year]
		@new_course.semester = course_params[:semester]
		@new_course.description = course_params[:description]
		@new_course.link = course_params[:link]
		@new_course.university = current_lecturer.university
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

	# [Define a Course - Story 1.1]
	# Description: This action passes and instance variable of the course and its
	#	discussionBoard to the edit view
	# Parameters:
	#	params[:id]: The current course's id
	# Returns: 
	#	@course
	#	@discussionBoard
	# Author: Mohamed Mamdouh
	def edit
		@course = Course.find_by_id(params[:id])
		if !@course.can_edit(current_lecturer)
			redirect_to :root
		end
		@discussion_board = @course.discussion_board
	end

	# [View a course - story 1.21]
	#Description: This action is resposible for the view of a specific course.
	#Parameters: 
	#   id: Course id
	# Returns: The view of the requested course
	# Author: Mohamed Metawaa
	def show
		@course = Course.find_by_id(params[:id])
		if @course
			@topics = @course.topics
			tracks = []
			@topics.each do |t|
				tracks = tracks + t.tracks
			end			
			@assignments = @course.assignments
			assignment_problems = []
			@assignments.each do |a|
				assignment_problems = assignment_problems + a.problems
			end
			@can_edit = @course.can_edit(current_lecturer)
			@can_edit||= @course.can_edit(current_teaching_assistant)
		else
			render ('public/404')
		end
	end

	def manage
	end

	# [Edit a course - story 1.17]
	#Description: This action is resposible for editing a specific course.
	#Parameters: 
	#   id: Course id
	# Returns:
	# 	null
	# Author: Mohamed Metawaa
	def update
		@course = Course.find_by_id(params[:id])
		@discussion_board = @course.discussion_board
		if @course.update(course_params)
			@topics = @course.topics
			render 'show'
		else 
			render 'edit' 
		end
	end

	# [Share Performance - Story 5.2, 5.13]
	# Updates the database with the value of whether to share
	# 	performance or not and it redirects to an error page if an error
	# 	occurs
	# Parameters:
	#	params[:id]: The course id
	# 	params[:value]: The decision of the student whether to share his
	# 		performance or not
	# Returns: none
	# Author: Khaled Helmy
	def share
		if student_signed_in?
			student_id = current_student.id
			course_id = params[:id]
			value = to_boolean params[:value]
			result = CourseStudent.where("student_id = ? AND course_id = ?",
				student_id, course_id)[0]
			if result.share == value
				render ('public/404')
			else
				result.update(share: value)
				redirect_to "/courses"
			end
		else
			render ('public/404')
		end
	end

	private
		def course_params 
			params.require(:course).permit(:name,:code,:year,:semester,:description,:link)
		end

		# [Share Performance - Story 5.2, 5.13]
		# Fetches the sharing status for each course that the current
		# 	signed in student is subscribing to in the database, appends them in
		# 	a list and returns that list
		# Parameters: none
		# Returns:
		# 	An array that contains the sharing status of each course for the
		# 	current signed in student
		# Author: Khaled Helmy
		def find_state courses
			states = Hash.new
			student_id = current_student.id
			puts student_id
			courses.each do |c|
				course_id = c.id
				result = CourseStudent.where("student_id = ? AND course_id = ?",
					student_id, course_id)[0]
				if result.share == false
					states[result.course_id] = "Show"
				else
					states[result.course_id] = "Hide"
				end
			end
			return states
		end

		# [Share Performance - Story 5.2, 5.13]
		# Converts a string consisting of either "true" or "false"
		# 	into the corresponding boolean value
		# Parameters:
		# 	value: String consisting of "true" or "false" to be converted to boolean
		# Returns:
		# 	A boolean converted from a string
		# Author: Khaled Helmy
		def to_boolean value
			if value == "true"
				return true
			else
				return false
			end
		end

end
