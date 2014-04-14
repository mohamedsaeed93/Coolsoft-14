class TestCase < ActiveRecord::Base
	#Validations
    validates :input , :output , :presence => true 
    validates :input , :length => { :minimum => 1 }
	validates :output, :length => { :minimum => 1 }
	validates :input , :length => { :maximum => 25}
	validates :output, :length => { :maximum => 25 }

	#Relations
	belongs_to :owner, polymorphic: true
	belongs_to :problem

	#Scoops

	#Methods
	
end
