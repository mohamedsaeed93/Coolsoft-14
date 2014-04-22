class PostsController < ApplicationController

	# [Add Post - Story 1.13]
	# Description: This action takes the passed discussion board id and assigns
	#              the discussion board with that id to an instance variable.
	# Parameters:
	#	params[:discussion_board_id]: The discussion board id
	# Returns: 
	# 	none
	# Author: Ahmed Atef
	def new
		@discussion_board = DiscussionBoard.find_by_id(params[:discussion_board_id])
		@new_post = Post.new
	end

	def show
	  	@post = Post.find(params[:id])
	  	@replies = @post.replies.order("created_at desc")
	end	  	

	# [Edit Post - Story 1.18]
	# Description: This action takes the passed post id 
	#               to be passed to the Edit form.
	# Parameters:
	#	params[:id]: The post id
	# Returns: 
	# 	none
	# Author: Ahmed Atef
	def edit
		@post = Post.find(params[:id])
	end

	# [Delete Post- Story 1.15]
	# This action takes the post id, remove it from the database
	#	and then redirects the user to the show page of the discussion board
	#	with a "Post successfully Deleted" message.
	# Parameters:
	#	params[:id]: The current post's id
	# Returns: 
	#	flash[:notice]: A message indicating the success of the deletion
	# Author: Ahmed Atef
	def destroy
			@dis = Post.find_by_id(params[:id]).discussion_board_id
			if Post.find_by_id(params[:id]).destroy
				flash[:notice] = "Post successfully Deleted"
				redirect_to(:controller => 'discussion_boards' , :action => 'show' ,:id => @dis)
			end
	end		
	# [Add Post - Story 1.13]
	# Description: This action takes the passed parameters from 
	#              the add post form, creates a new Post record
	#              and assigns it to the respective discussion board.If the 
	#              creation fails the user is redirected to the form
	# Parameters:
	#	topic_params[]: A list that has all fields entered by the user to in the
	# 					add_post_form
	# Returns: 
	# 	flash[:notice]: A message indicating the success or failure of the creation
	# Author: Ahmed Atef
	def create
		@new_post = Post.new(post_params)
		@new_post.views_count = 0
		if lecturer_signed_in?
			@new_post.owner_id = current_lecturer.id
			@new_post.owner_type = "lecturer"
		elsif teaching_assistant_signed_in?
			@new_post.owner_id = current_teaching_assistant.id
			@new_post.owner_type = "teaching assistant"
		elsif student_signed_in
			@new_post.owner_id = current_student.id
			@new_post.owner_type = "student"
		end
		if @new_post.save
			flash[:notice] = "Post successfully created"
			@discussion_board = DiscussionBoard.find(discussion_board_params[:discussion_board_id])
			@discussion_board.posts << @new_post
		else
			if @new_post.errors.any?
				flash[:notice] = @new_post.errors.full_messages.first
			end
			render :action => 'new'  
		end
	end

	# [Edit Post - Story 1.18]
	# Description: This action takes the passed parameters from 
	#              the edit post form, updates the passed post parameters.If the 
	#              update fails the user is redirected to the form
	# Parameters:
	#	topic_params[]: A list that has all fields entered by the user to in the
	# 					Edit_post_form
	# Returns: 
	# 	flash[:notice]: A message indicating the success or failure of the creation
	# Author: Ahmed Atef
		def update
		@post = Post.find(params[:id])
		if @post.update_attributes(post_params) 
			flash[:notice] = "Post successfully updated"
			redirect_to(:action => 'show' ,:id => @post.id)
		else
			if @post.errors.any?
				flash[:notice] = @post.errors.full_messages.first
			end
			render :action => 'edit'  
		end
	end

	# [Add Post - story 1.13]
	# private method. Controls the post form parameters that can be accessed.
	# Parameters: 
	# 	content: The content of the Post
	# 	title: The title of the Post
	# 	discussion_board_id: hidden field for the discussion board id
	# Returns: None
	# Author: Ahmed Atef
	private
		def post_params 
			params.require(:post).permit(:content,:title)
		end

		def discussion_board_params 
			params.require(:post).permit(:discussion_board_id)
		end		
end