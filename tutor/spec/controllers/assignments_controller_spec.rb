require 'spec_helper'
include Devise::TestHelpers
class ActiveSupport::Assignment
	include Devise::TestHelpers
end

describe AssignmentsController do
	before (:all) do
		@lecturer = Lecturer.new(email: '1@lecturer.com', password: '123456789',
			password_confirmation: '123456789', name: 'LecturerI',
			confirmed_at: Time.now, dob: DateTime.now.to_date, gender: true,
			degree: "PhD", university: "GUC", department: "MET")
		@lecturer.save!
		@course = Course.new(name:"SE2",
			code:"Se2", year:2014, semester:6, :description => "last sprint",
			:link => "http://met.guc.edu.eg/")
		@course.save!
	end

  	it "new returns http success" do
		sign_in @lecturer
		get :new
		expect(response).to be_success
  	end

	context "CREATE" do
		it "creates a new assignment" do
			sign_in @lecturer
			expect{
				get :create, assignment: {:title => "Assignmentse",
					:description => "try to solve", "date(1i)" => "2014",
					"date(2i)" => "12","date(3i)" => "12",},:course_id => @course.id
			}.to change(Assignment,:count).by(1)
		end
		it 'is invalid assignment without title' do
			sign_in @lecturer
			expect{
				get :create, assignment: {
				:description => "try to solve1", "date(1i)" => "2014",
				"date(2i)" => "12","date(3i)" => "12",},:course_id => @course.id
			}.to change(Assignment,:count).by(0)
		end
	end
end