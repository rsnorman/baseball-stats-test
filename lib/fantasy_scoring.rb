module BaseballStats

	# Library for making it easy to calculate fantasy score and also change scoring points
	module FantasyScoring
		
		# Reads the scoring definitions from a config file at config/fantasy_scoring.json
		# @return [Hash] fantasy scoring definitions
		def self.scoring_definitions
			@fantasy_scoring ||= JSON.parse(File.read("config/fantasy_scoring.json"))
		end


		# Gets the fantasy stats for a player for a full year
		# @param [Integer] year to calculate score for fantasy year
		# @return [Integer] fantasy score for the year
		# @note Only works for attributes right now, not sure if hitting formulas will be used in fantasy scoring
		def fantasy_score_for_hitter(year)
			score = 0
			stats = hitting_stats(:yearID => year)

			# Loop through all stats defined in HittingStatSummary and see if they are used to
			# determine fantasy score
			HittingStatSummary.stat_definitions.each_pair do |abbr, stat_name|
				if FantasyScoring.scoring_definitions.has_key?(abbr.to_s)
					score += stats.sum{|x| x.send(stat_name)} * FantasyScoring.scoring_definitions[abbr.to_s]
				end
			end

			score
		end
	end
end