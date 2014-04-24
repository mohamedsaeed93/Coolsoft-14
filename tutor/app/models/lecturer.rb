class Lecturer < ActiveRecord::Base
	devise :database_authenticatable, :registerable,
			:recoverable, :rememberable, :trackable,
			:validatable, :confirmable

	#Uploader
	mount_uploader :profile_image, ProfileImageUploader

	#Validations
	validate :duplicate_email
	validates :name, presence: true
	validates_format_of :name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z|\A\z/
	validates :degree, presence: true
	validates_format_of :degree, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z|\A\z/
	validates :university, presence: true
	validates_format_of :university, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z|\A\z/
	validates :department, presence: true
	validates_format_of :department, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z|\A\z/
	validates :dob, presence: true

	#Relations
	has_and_belongs_to_many :courses, join_table: "courses_lecturers"
	has_and_belongs_to_many :worked_with, class_name:"TeachingAssistant", join_table: "lecturers_teaching_assistants"
	
	has_many :posts, as: :owner, dependent: :destroy
	has_many :replies, as: :owner, dependent: :destroy
	has_many :topics
	has_many :tracks, as: :owner
	has_many :problems, as: :owner
	has_many :model_answers, as: :owner
	has_many :method_constraints, as: :owner
	has_many :method_parameters, as: :owner
	has_many :variable_constraints, as: :owner
	has_many :test_cases, as: :owner
	has_many :hints, as: :owner
	has_many :acknowledgements, dependent: :destroy

	#Methods

	# [User Authentication Advanced - Story 5.9, 5.10, 5.11, 5.14, 5.15]
	# Checks if the email is already registered in tables: Student and TeachingAssistant
	# 	before registering the email for table: Lecturer
	# Parameters: None
	# Returns: None
	# Author: Khaled Helmy
	def duplicate_email
		if Student.find_by email: email or TeachingAssistant.find_by email: email
			errors.add(:email, "has already been taken")
		end
	end

end