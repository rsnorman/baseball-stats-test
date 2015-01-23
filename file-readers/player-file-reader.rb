module BaseballStats
	
	# Class that reads the files that contain all the players
	class PlayerFileReader < BaseballStats::FileReaderBase

		# Stores all player data using Player model
		# @param [Array<Hash>] players_data from file
		# @return [Array<Player>] players created from file
		def self.store(players_data)
			players = []
			errors = []
			players_data.each do |player_data|
				begin
					players << Player.create(player_data)
				rescue Exception => e
					errors << {:error => e, :player_data => player_data}
				end
			end

			BaseballStats.log "Stored #{players.size} players", :color => :green
			BaseballStats.log "#{errors.size} Bad Rows", :color => :red

			# errors.each do |e|
			# 	BaseballStats.log "Error: #{e[:error]}: #{e[:player_data].inspect}", "1;31;40"
			# end

			players
		end
	end
end