#!/usr/bin/env ruby

#Creates a folder calls outputs with the output of the program being run
#This script must be run in the same dir as the program 

require 'open3'

start_index = 3
program_name = ARGV[0]
sol_path = ARGV[1]
mode = ARGV[2]
output_dir = "outputs"
inputs = []
commands = []
solutions = []
outputs = []
command = "gdb "

# --- Clean up ---
Open3.capture3("rm -rf " + output_dir)
Open3.capture3("mkdir " + output_dir)

def get_dir_files(dir_path)
	stdout, stderr, status = Open3.capture3("ls -R " + dir_path)
	tmp = stdout.split("\n")
	tmp = tmp[1, tmp.length - 1]

	return tmp
end

# --- Prepare for program execution ---

for i in start_index...ARGV.length
	inputs.push(get_dir_files(ARGV[i]))
end

for i in 0...inputs[0].length
	args = ""
	valid = true

	for n in 0...inputs.length
		file_name = inputs[n][i]
		
		if file_name == "." || file_name == ".."
			valid = false
			next
		end
		
		args = args + " " + ARGV[n + start_index] + file_name
	end

	if valid 
		if mode == "file" then commands.push(command + program_name + args) end
		if mode == "stdin" then commands.push(command + program_name + " < " + args) end
	end
end

for i in 0...commands.length
	puts "Running: " + commands[i] + " > " + output_dir + "/output_" + i.to_s
	stdout, stderr, status = Open3.capture3(commands[i] + " > " + output_dir + "/output_" + i.to_s)
end

# --- Compare outputs and solutions --- 

solutions.push(get_dir_files(sol_path))
outputs.push(get_dir_files(output_dir))


for i in 0...solutions[0].length
	sol_name = solutions[0][i]
	output_name = outputs[0][i]

	command = "diff " + sol_path + sol_name + " " + output_dir + "/" + output_name

	if sol_name == "." || sol_name == ".." || output_name == "." || output_name == ".." then next end

	puts "Running: " + command 
	stdout, stderr, status = Open3.capture3(command)

	if stdout.length > 0 then puts stdout
	else puts "No difference" end
end
