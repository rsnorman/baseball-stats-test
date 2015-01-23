module BaseballStats

	# Hitter formulas that can be added to a Player model
	module HitterFormulas
	
		# Gets the batting averge for a player for their career or just one year
		# @param [Integer] year to get batting average
		# @return [Float] batting average for the player
		def batting_average(year = nil)
			_stats = year.nil? ? hitting_stats : hitting_stats(:yearID => year)
			return 0 if _stats.empty?

			at_bats_total = _stats.sum(&:at_bats).to_f
			
			return 0.0 if at_bats_total.zero? # return 0% slugging percentage since there were no at bats, stops divide by 0 error

			(_stats.sum(&:hits) / at_bats_total).round(3)
		end

		# Gets the slugging percentage for a player for their career or just one year
		# Formula: ((Hits – doubles – triples – home runs) + (2 * doubles) + (3 * triples) + (4 * home runs)) / at-bat
		# @param [Integer] year to get slugging percentage
		# @return [Float] slugging percentage for the player
		def slugging_percentage(year = nil)
			_stats = year.nil? ? hitting_stats : hitting_stats(:yearID => year)

			HitterFormulas.calculate_slugging_percentage(_stats)
		end

		# Calculates the slugging percentage from an array of stats
		# @param [Array<HittingStatSummary>] _stats to calculate slugging percentage
		# @return [Float] sluggin percentage for the player
		def self.calculate_slugging_percentage(_stats)
			return 0 if _stats.empty?

			at_bats_total = _stats.sum(&:at_bats).to_f
			
			return 0.0 if at_bats_total.zero? # return 0% slugging percentage since there were no at bats

			(((_stats.sum(&:hits) - _stats.sum(&:doubles) - _stats.sum(&:triples) - _stats.sum(&:home_runs)) + (2 * _stats.sum(&:doubles)) + (3 * _stats.sum(&:triples)) + (4 * _stats.sum(&:home_runs))) / at_bats_total).to_f.round(3)
		end
	end
end