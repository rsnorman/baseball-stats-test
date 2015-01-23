module BaseballStats
	class TripleCrownWinnersIn20112012 < Report
		
		def self.calculate

			players = Player.all_with_hitting_stats
			# BaseballStats.log "Found #{players.count} players with hitting stats"

			self.find_triple_crown_winner_for_year(players, 2011)
			self.find_triple_crown_winner_for_year(players, 2012)
			
		end

		def self.find_triple_crown_winner_for_year(players, year)

			BaseballStats.log "Calculating Triple Crown Winner for #{year}..."
			most_RBIs = 0
			most_RBIs_player = nil
			most_HRs = 0
			most_HRs_player = nil
			highest_BA = 0.0
			highest_BA_player = nil


			players.each do |player|
				stats = player.hitting_stats(:yearID => year)
				rbis = stats.sum(&:runs_batted_in)
				hrs = stats.sum(&:home_runs)
				ba = stats.sum(&:hits) > 200 ? player.batting_average(year) : 0.0
				most_RBIs_player = player and most_RBIs = rbis if rbis > most_RBIs
				most_HRs_player = player and most_HRs = hrs if hrs > most_HRs
				highest_BA_player = player and highest_BA = ba if ba > highest_BA
			end

			BaseballStats.log "#{most_RBIs_player.name} had the most runs batted in for #{year} at #{most_RBIs}"
			BaseballStats.log "#{most_HRs_player.name} had the most home runs in for #{year} at #{most_HRs}"
			BaseballStats.log "#{highest_BA_player.name} had the highest batting average in for #{year} at #{highest_BA.to_batting_average}"

			if [most_RBIs_player.playerID, most_HRs_player.playerID, highest_BA_player.playerID].uniq.length == 1
				BaseballStats.log "#{most_RBIs_player.name} was the Triple Crown Winner in #{year}!", :color => :blue
			else
				BaseballStats.log "There was no Triple Crown Winner in #{year}", :color => :red
			end
		end

		def self.name
			"Triple Crown Winner in 2011 and 2012"
		end
	end
end