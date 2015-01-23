module BaseballStats

	# Class that models a baseball player
	class HittingStatSummary < ModelBase
		include BaseballStats::StatDefinitions
		
		set_indexes :playerID, :teamID, :yearID

		attr_accessor :playerID, :teamID, :yearID

		# Define hitting stats
		define_stats({
			:G => 'games',
			:AB => 'at_bats',
			:R => 'runs',
			:H => 'hits',
			:"2B" => 'doubles',
			:"3B" => 'triples',
			:HR => 'home_runs',
			:RBI => 'runs_batted_in',
			:SB => 'stolen_bases',
			:CS => 'caught_stealing'
		})

		# Returns the player tied to the stat
		# @return [Player] player tied to the stat
		def player
			Player.find(self.playerID)
		end
	end
end