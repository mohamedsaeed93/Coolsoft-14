class SolutionsLayer

	# [Layer - Story X.3]
	# Test the given code against the given case
	# Parameters:
	# 	lang: The programming language used in execution
	# 	code: The code to be executed
	# 	student_id: The id of the current signed in student
	# 	problem_id: The id of the problem being solved
	# 	cases: The input to test against
	# Returns: 
	#	A hash with the status of the execution
	# Author: Mussab ElDash
	def self.execute lang, code, student_id, problem_id, problem_type, class_name, cases
		executer = get_executer lang
		unless executer
			return false
		end
		compiler = get_compiler lang
		solution = get_solution code, student_id, problem_id, problem_type, class_name
		compile_status = {}
		if compiler
			compile_status = compiler.compiler_feedback(solution)
			unless compile_status[:success]
				return {compiler_error: true, compiler_output: compile_status}
			end
		else
			create_file lang, solution
		end
		p cases
		return executer.execute(solution, cases)
	end

	# [Layer - Story X.3]
	# Compile the given in the given language
	# Parameters:
	# 	lang: The programming language used in compilation
	# 	code: The code to be compiled
	# 	student_id: The id of the current signed in student
	# 	problem_id: The id of the problem being solved
	# Returns: 
	#	The compile status
	# Author: Mussab ElDash
	def self.compile lang, code, student_id, problem_id, problem_type, class_name
		compiler = get_compiler lang
		solution = get_solution code, student_id, problem_id, problem_type, class_name
		if compiler
			feed_back = compiler.compiler_feedback solution
			if feed_back[:success]
				solution.status = 3
			else
				solution.status = 2
			end
			return feed_back
		else
			return
		end
	end

	# [Layer - Story X.3]
	# Test the given code against the test cases in the database
	# Parameters:
	# 	lang: The programming language used in validation
	# 	code: The code to be validated
	# 	student_id: The id of the current signed in student
	# 	problem_id: The id of the problem being solved
	# 	time: The time the student spent to solve the problem
	# Returns: 
	#	A hash with the validation status
	# Author: Mussab ElDash
	def self.validate lang, code, student_id, problem_id, problem_type, class_name, time
		solution = get_solution code, student_id, problem_id, problem_type, class_name
		solution.time = time
		test_cases = solution.problem.test_cases
		compiler = get_compiler lang
		if compiler
			feed_back = compiler.compiler_feedback solution
			if feed_back[:success]
				return Solution.validate solution, test_cases
			end
		else
			create_file lang, solution
		end
		return {compiler_error: true, compiler_output: feed_back}
	end

	# [Layer - Story X.3]
	# Debug the given code and use the given case as an input
	# Parameters:
	# 	lang: The programming language used in debugging
	# 	code: The code to be debugged
	# 	student_id: The id of the current signed in student
	# 	problem_id: The id of the problem being solved
	# 	cases: The input to debug against
	# Returns: 
	#	A hash with the debugging results
	# Author: Mussab ElDash
	def self.debug lang, code, student_id, problem_id, problem_type, class_name, cases
		solution = get_solution code, student_id, problem_id, problem_type, class_name
		debugger = get_debugger lang
		compiler = get_compiler lang
		if debugger
			if compiler
				compile_status = compiler.compiler_feedback(solution)
				unless compile_status[:success]
					return {:success => false, data: compile_status}
				end
			else
				create_file lang, solution
			end
			debugger.debug solution, cases
		else
			return
		end
	end

	# [Layer - Story X.3]
	# Creates a new solution for future use
	# Parameters:
	# 	code: The code to be debugged
	# 	student_id: The id of the current signed in student
	# 	problem_id: The id of the problem being solved
	# Returns:
	#	A new Solution
	# Author: Mussab ElDash
	def self.get_solution code, student_id, problem_id, type = "Problem", class_name
		type = type.capitalize
		solution = Solution.create({code: code, student_id: student_id,
				problem_id: problem_id, problem_type: type, class_name: class_name})
		return solution
	end

	# [Layer - Story X.3]
	# Get the Executer Class of the give language
	# Parameters:
	# 	lang: The programming language to get the executer of
	# Returns: 
	#	The Executer Class
	# Author: Mussab ElDash
	def self.get_executer lang
		lang = lang.capitalize
		executer_string = lang + "Executer"
		begin
			executer = eval executer_string
		rescue Exception => e
			executer = false
		end
		return executer
	end

	# [Layer - Story X.3]
	# Get the Compiler Class of the give language
	# Parameters:
	# 	lang: The programming language to get the compiler of
	# Returns: 
	#	The Compiler Class
	# Author: Mussab ElDash
	def self.get_compiler lang
		lang = lang.capitalize
		compiler_string = lang + "Compiler"
		begin
			compiler = eval compiler_string
		rescue Exception => e
			compiler = false
		end
		return compiler
	end

	# [Layer - Story X.3]
	# Get the Debugger Class of the give language
	# Parameters:
	# 	lang: The programming language to get the debugger of
	# Returns: 
	#	The Debugger Class
	# Author: Mussab ElDash
	def self.get_debugger lang
		lang = lang.capitalize
		debugger_string = lang + "Debugger"
		begin
			debugger = eval debugger_string
		rescue Exception => e
			debugger = false
		end
		return debugger
	end

	# [Debugger: Debug Pyhton - Story X.8]
	# Creates a file for the choosen language
	# Parameters:
	# 	lang: The language to create the file for
	# 	solution: The solution to create the file for
	# Returns: none
	# Author: Mussab ElDash
	def self.create_file lang, solution
		folder_name = solution.folder_name
		file_path = get_extension(lang)
		file_path = solution.file_path(false) + file_path
		%x[ #{'mkdir -p ' + Solution::SOLUTION_PATH + folder_name} ]
		File.open(file_path, 'w') { |file| file.write(solution.code) }
	end

	# [Debugger: Debug Pyhton - Story X.8]
	# Gets the extension of the choosen language
	# Parameters:
	# 	lang: The language to get the file extension for
	# Returns: The extension of the passed language
	# Author: Mussab ElDash
	def self.get_extension lang
		lang = lang.capitalize
		if lang === "Java"
			return ".java"
		elsif lang === "Python"
			return ".py"
		end
	end
end
