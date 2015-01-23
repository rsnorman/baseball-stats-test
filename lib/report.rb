module BaseballStats

	# Base class for reports
	class Report
		
		# Grabs all reports from reports folder
		# @return [Array<Report>] reports listed in reports folder
		def self.all
			BaseballStats.log "Grabbing reports..."
			reports = []

			Dir["reports/*.rb"].each do |filepath|
				filename = filepath.split('/').last.gsub('.rb', '')

				# BaseballStats.log "Loading report named for #{filename.humanize}"
				reports << "BaseballStats::#{filename.camelize}".constantize
			end

			reports
		end


		# Runs the report and prints out time spent executing report
		def self.run
			start_time = Time.now
			BaseballStats.separator
			BaseballStats.log "Running #{self.name}"
			self.calculate
			BaseballStats.log "Finished running report. Took #{Time.now - start_time} seconds.", :color => :green
			BaseballStats.separator
		end


		# Must be overridden by child class
		def self.calculate
			raise "Must be overridden by child class"
		end


		# Returns the name of the report
		def self.name
			self.to_s.split("::").last.underscore.humanize
		end
	end
end