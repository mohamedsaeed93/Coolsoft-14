class Problem < ActiveRecord::Base
	
	#Validations

	#Relations
	belongs_to :owner, class_name: 'Stuff', foreign_key: :stuff_id
	belongs_to :track

	has_many :model_answers, dependent: :destroy
	has_many :test_cases, dependent: :destroy
	has_many :solutions

	#Scoops
	
	#Methods



end
