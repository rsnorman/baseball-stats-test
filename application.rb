require 'rubygems'
require 'bundler/setup'

Bundler.require

require 'active_support/all'

Dir["./lib/*.rb"].each {|f| require f}
Dir["./file-readers/*.rb"].each {|f| require f}
Dir["./helpers/*.rb"].each {|f| require f}
Dir["./models/*.rb"].each {|f| require f}
Dir["./reports/*.rb"].each {|f| require f}

# Namespace for BaseballStats library
module BaseballStats
	extend BaseballStats::CommandLinePrompt

	# Helper method for logging
	# @param [String] message
	# @param [Hash] options
	def self.log(*args) #msg, options
		print(*args)
	end

	# Entrance method into progrm
	def self.run
		log "Baseball Stats Running...", :color => :green


		separator
		log "Loading all data..."

		Dir["data/players/*.csv"].each do |file|
			PlayerFileReader.parse(file)
		end

		Dir["data/stats/hitting/*.csv"].each do |file|
			StatsFileReader.parse(file)
		end


		separator
		log "Listing reports...", :color => :green
		reports = Report.all

		report_number = 1
		while report_number != 0
			report_number = nil
			reports.each_with_index do |report, index|
				log "#{index + 1}. #{report.name}"
			end

			log "#{reports.size + 1}. Exit"

			report_number = prompt "Select report above:"
			report_number = report_number.to_i

			if report_number > 0 && report_number <= reports.size
				reports[report_number - 1].run
			else
				break
			end
		end


		log "Finished running BaseballStats!", :color => :green
	end
end

BaseballStats.run unless ENV == 'test'