module BaseballStats
	class Top5FantasyPlayerGainsFrom2011To2012 < Report

		def self.calculate
			players = Player.all_with_hitting_stats
			# BaseballStats.log "Found #{players.count} players with hitting stats"

			BaseballStats.log "Calculating fantasy scoring for all players..."
			player_fantasy_scoring_differences = []
			players.each do |p|
				total_at_bats = p.hitting_stats(:yearID => 2011).sum(&:at_bats) + p.hitting_stats(:yearID => 2012).sum(&:at_bats)
				
				if total_at_bats > 500
					fantasy_score_in_2011 = p.fantasy_score_for_hitter(2011)
					fantasy_score_in_2012 = p.fantasy_score_for_hitter(2012)

					player_fantasy_scoring_differences << [p, fantasy_score_in_2011 - fantasy_score_in_2012, fantasy_score_in_2011, fantasy_score_in_2012]
				end
			end

			player_fantasy_scoring_differences.sort{|x, y| y[1] <=> x[1]}[0..4].each_with_index do |fantasy_scoring_dif_for_player, index|
				player = fantasy_scoring_dif_for_player[0]
				fantasy_scoring_dif = fantasy_scoring_dif_for_player[1]
				BaseballStats.log "#{index + 1}. #{player.name} - Improved #{fantasy_scoring_dif} Points", :color => :blue
			end
		end

		def self.name
			"Top 5 Fantasy Player Gains From 2011 To 2012"
		end
	end
end