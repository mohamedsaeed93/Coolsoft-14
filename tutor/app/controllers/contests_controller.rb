class ContestsController < ApplicationController

	def index
		@contests = Contest.all
	end

	# [Contest Registration - Story 5.24]
	# Add the current student to the choosen contest
	# Parameters:
	# 	params[:id]: The current contest id
	# Returns:
	# 	none
	# Author: Rania Abdel Fattah
	def register
			if student_signed_in?
			contest = Contest.find_by_id(params[:id])
			current_student.contests << contest
			redirect_to "/contests"
			end
	end

	before_action :validate_timer

	private

		# [Contest Timer - Story 5.28]
		# Checks the state of the timer based on the date and time of a specific contest
		# 	and affecting the behaviour of the timer and the message that accompanies it
		# 	based on the timing of the contest. If the contest didn't start yet, the timer
		# 	will be set to countdown till the start of the contest and the message appearing
		# 	will be 'Contest starts in'. If the contest has started, the timer will be set
		# 	to countdown till the end of the contest and the message will be 'Contest ends in'.
		# 	If the contest has ended, the timer will disappear and the message will be
		# 	'Contest has finished!'.
		# Parameters:
		# 	params[:id]: an Integer containing the id of a specific contest to have its timer.
		# Returns:
		# 	@timer: a String representation of a DateTime object representing the date
		# 		and the time of the contest that will be used by the timer.
		# 	@message: a String containing the message accompanying the timer.
		# 	@del: a Boolean indicating if the contest has finished which affects the
		# 		behaviour of the timer; whether to remove it or not.
		# Author: Khaled Helmy
		def validate_timer
			@contest = Contest.find(params[:id])
			contest_start = @contest.start_time
			contest_end = @contest.end_time
			current = DateTime.now
			if current < contest_start
				@timer = contest_start
				@message = "Contest starts in"
				@del = false
			elsif current <= contest_end
				@timer = contest_end
				@message = "Contest ends in"
				@del = false
			else
				@timer = nil
				@message = "Contest has finished!"
				@del = true
			end
		end

end
