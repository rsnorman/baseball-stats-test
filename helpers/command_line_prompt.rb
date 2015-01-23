module BaseballStats

	# Module for helper methods for the command line
	module CommandLinePrompt

		# Prompts the user
		def prompt(msg)
			print("\n#{msg}", :color => :yellow, :skip_line_break => true)
	    	gets
		end

		# Adds separator
		def separator
			print "\n\n--------------------------------------------------------------\n\n"
		end

		# Prints a message
		def print(msg, options = {})
			options = {:color => nil, :skip_line_break => false}.merge(options)
			msg = "\n#{msg}" unless options[:skip_line_break]
			STDOUT.puts(options[:color].nil? ? msg : colorize(msg, options[:color]))
		end

		# Colorizes text
		def colorize(text, color)

			colors = {
				:blue => "1;36;40",
				:green => "1;32;40",
				:yellow => "1;33;40",
				:red => "1;31;40"
			}

  			"\e[#{colors[color]}m#{text}\e[0m"
		end
	end
end