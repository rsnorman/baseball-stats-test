module BaseballStats

	# Base class that any file reader class can inherit from and gain some easy to use methods
	class FileReaderBase

		# Parses the first row of a file and return and array of header names
		# @param [File] file that will have headers read
		# @return [Array<String>] array of header titles
		def self.parse_header(file)
			file.each do |row|
				return row.split(',').collect{|x| x.strip}
			end
		end


		# Parses a CSV file from a file name then stores it calling overridden store method
		# @param [String] filename of file to be parsed
		# @return [Array<Hash>] array of data assiged to correct header keys
		def self.parse(filename)
			start_time = Time.now

			BaseballStats.log "Parsing file: #{filename}"
			data = self.read_file(filename)
			self.store(data)

			total_time = Time.now - start_time

			BaseballStats.log "File took #{total_time} seconds to parse and store"
		end

		# Reads a CSV file from a file name. Return data as an array of hashes created from first row of headers and remaining data
		# @param [String] filename of file to be parsed
		# @return [Array<Hash>] array of data assiged to correct header key
		def self.read_file(filename)
			data = []
			file = File.open(filename, 'r')

			# Read first line
			headers = self.parse_header(file)

			# Read the rest of the file
			file.each do |row|
				row_data = {}
				row.split(',').each_with_index do |cell, index|
					row_data[headers[index]] = cell.strip
				end
				data << row_data
			end

			data
		end

		# Method that stores the data
		# @note Must be overridden in child class
		def self.store(data)
			raise "Need to implement read"
		end

	end
end