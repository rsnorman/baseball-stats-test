module BaseballStats
	class MostImprovedBattingAverageFrom2009To2010 < Report

		def self.calculate
			players = Player.all_with_hitting_stats
			# BaseballStats.log "Found #{players.count} players with hitting stats"

			BaseballStats.log "Calculating batting averages for all players..."
			player_batting_average_differences = []
			players.each do |p|

				if p.hitting_stats(:yearID => 2009).sum(&:at_bats) > 200
					batting_average_in_2009 = p.batting_average(2009)

					if p.hitting_stats(:yearID => 2010).sum(&:at_bats) > 200
						batting_average_in_2010 = p.batting_average(2010)

						player_batting_average_differences << [p, batting_average_in_2010 - batting_average_in_2009, batting_average_in_2009, batting_average_in_2010]
					end
				end
			end


			top_improvement = player_batting_average_differences.sort{|x, y| y[1] <=> x[1]}[0]
			

			BaseballStats.log "#{top_improvement[0].name} had the most improved batting average from 2009-2010. Going from #{top_improvement[2].to_batting_average} to #{top_improvement[3].to_batting_average}, improving #{top_improvement[1].to_batting_average}!", :color => :blue
		end

		def self.name
			"Most Improved Batting Average From 2009 to 2010"
		end
	end
end