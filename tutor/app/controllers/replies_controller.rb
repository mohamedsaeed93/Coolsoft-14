class RepliesController < ApplicationController
	
	before_action :current_user!
	# [Edit a Reply - Story 1.19]
	# Description: Shows the replies with id
	# Parameters:
	#	replies: reply with spacific id
	# Returns:
	# 	returns a the record in JSON form
	# Author: Ahmed Mohamed Magdi
	def show
		reply = Reply.find_by_id(params[:id])
		render json: reply
	end

	# [Post a Reply - Story 1.14]
	# Description: Creates new reply and save to the database
	# Parameters:
	#	reply_content: The content of the reply
	#	id: Post id for getting the post
	# Returns:
	# 	returns a the record in JSON form
	# Author: Ahmed Mohamed Magdi
	def create
		reply_content = params[:content]
		post = Post.find_by_id(params[:id])
		reply = Reply.new
		reply.content = reply_content
		if lecturer_signed_in?
			current_lecturer.replies << reply
		elsif teaching_assistant_signed_in?
			current_teaching_assistant.replies << reply
		else
			current_student.replies << reply
		end
		post.replies << reply
		render json: reply
	end

	# [Delete a Reply - Story 1.16]
	# Description: Deleting reply from the database
	# Parameters:
	#	id: reply id for getting the reply
	# Returns:
	# 	true: if it successed is destroying the reply
	# 	false: if it fails is destroying the reply
	# Author: Ahmed Mohamed Magdi
	def destroy
		reply = Reply.find(params[:id])
		if reply.destroy
			render json: true
		else
			render json: false
		end
	end

	# [Edit a Reply - Story 1.19]
	# Description: Updating a reply in the database
	# Parameters:
	#	id: reply id for getting the reply
	# Returns:
	# 	true: if it successed is saving the reply
	# 	false: if it fails is saving the reply
	# Author: Ahmed Mohamed Magdi
	def update
		reply = Reply.find(params[:id])
		data = params[:content]
		reply.content = data
		if reply.save
			render json: reply
		else
			render json: false
		end
	end

	private

	# [Design_layout - Story 2.13]
	# Description: Checking the current loged-in user
	# Parameters: none
	# Returns:
	# 	@current_user: The current loged-in user
	# Author: Ahmed Mohamed Magdi
	def current_user
		if student_signed_in?
			@current_user = current_student
		elsif lecturer_signed_in?
			@current_user = current_lecturer
		elsif teaching_assistant_signed_in?
			@current_user = current_teaching_assistant
		end
	end

end