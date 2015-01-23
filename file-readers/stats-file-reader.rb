module BaseballStats
	
	# Class that reads the files that contain all the players
	class StatsFileReader < BaseballStats::FileReaderBase

		# Stores all player data using Player model
		# @param [Array<Hash>] players_data from file
		# @return [Array<Player>] players created from file
		def self.store(stats_data)
			stats = []
			errors = []
			stats_data.each do |stat_data|
				begin
					stats << HittingStatSummary.create(stat_data)
				rescue Exception => e
					errors << {:error => e, :stat_data => stat_data}
				end
			end

			BaseballStats.log "Stored #{stats.size} stats", :color => :green
			BaseballStats.log "#{errors.size} Bad Rows", :color => :red

			# errors.each do |e|
			# 	BaseballStats.log "Error: #{e[:error]}: #{e[:stat_data].inspect}", "1;31;40"
			# end

			stats
		end
	end
end