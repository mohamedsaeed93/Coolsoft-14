class Executer

	def self.execute(file, input) 
		java_path = 'students_solutions/Java/'
		classes_path = 'students_solutions/Class'
		compile = %x[#{'javac -g -d ' + classes_path + ' ' + java_path + file + '.java' + ' 2>&1'}]
		if compile.empty?
			problem_id = 3
			validity = check_input_validity(input, problem_id)
			if validity[:status]
				@execute_res = %x[#{'java -cp ' + classes_path + ' ' + file + ' ' + input + ' 2>&1'}]
				if @execute_res.empty?
					true
				else
					false
				end
			else
				@execute_res = validity[:msg]
				return false
			end
		end
	end

	def self.check_input_validity(input, problem_id)
		# variables_number = Problem.find_by_id(problem_id).variable_constraints.count
		variables_number = 2
		if input.include?("\n")
			return {status: false, msg: "Input can not have line breaks \"don't use enter\""}
		end
		if input.split(" ").count == variables_number
			return true
		else
			msg = "Enter only " + variables_number.to_s + " numbers"
			return {status: false, msg: msg}
		end
	end

	def self.get_runtime_error()
		if @execute_res.include?("/ by zero")
			return msg = {error: @execute_res, 
					explaination: "Division by Zero results in infinity, which computers can not understand. Be carefull !"}
		else
			return msg = {error: @execute_res, 
					explaination: "To be set Runtime Error!"}
		end
	end

	def self.get_output() 
		return @execute_res
	end

end

# Executer.execute(ARGV[0], ARGV[1])
# Executer.get_runtime_error()