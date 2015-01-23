module BaseballStats
	class SluggingPercentageFor2007OaklandAs < Report
		def self.calculate
			BaseballStats.log "Calculating team slugging percentage for Oakland Atheletics..."

			oakland_stats = HittingStatSummary.where(:teamID => "OAK", :yearID => 2007)

			oakland_stats.each do |stat|
				slugging_percentage = HitterFormulas.calculate_slugging_percentage([stat])
				BaseballStats.log "#{stat.player.name} - #{slugging_percentage.to_batting_average}", :skip_line_break => true if slugging_percentage > 0
			end

			oakland_team_slugging_percentage = HitterFormulas.calculate_slugging_percentage(oakland_stats)

			BaseballStats.log "The total team slugging percentage for the Oakland Athletics in 2007: #{oakland_team_slugging_percentage.to_batting_average}", :color => :blue
		end

		def self.name
			"Slugging Percentage For 2007 Oakland Athletics"
		end
	end
end
