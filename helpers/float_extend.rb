class Float

	# Extend float method to be able to display batting percentage
	# @return [String] value formatted to be a batting average
	def to_batting_average
		batting_average_string = self.round(3).to_s.split('.').last
		(3 - batting_average_string.size).times do
			batting_average_string += "0"
		end

		".#{batting_average_string}"
	end
end