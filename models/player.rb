module BaseballStats

	# Class that models a baseball player, models both pitcher and hitter since National League players can be both
	class Player < ModelBase
		include BaseballStats::HitterFormulas
		include BaseballStats::FantasyScoring
	
		attr_accessor :playerID, :birthYear, :nameFirst, :nameLast

		set_indexes :playerID

		# Returns only players that have hitting stats
		# @returns [Array<Player>] returns all players that have hitting stats
		def self.all_with_hitting_stats
			self.all.select{|x| !x.hitting_stats.empty? }
		end

		# Finds a player from a playerID
		# @params [String] playerID that identifies player
		# @return [Player] player that was found
		# @note Will raise error if player could not be found
		def self.find(playerID)
			player = self.find_by_playerID(playerID) #self.indexes[:playerID][playerID]

			raise("Player could not be found with id of '#{playerID}'") if player.nil?

			player
		end

		# Overrides create method to make sure duplicate players are not added
		def self.create(attributes = {})
			attributes = HashWithIndifferentAccess.new(attributes)
			raise "Cannot create duplicate players with the same playerID" if self.find_by_playerID(attributes[:playerID])
			
			super
		end

		# Returns the first and last name of a player
		# @return [String] full name of a player
		def name
			"#{self.nameFirst} #{self.nameLast}"
		end

		# Gets all hitting stats for a player
		# @params [Hash] conditions for selecting stats
		# @return [Array<HittingStatSummary>] hitting stats matching conditions
		def hitting_stats(conditions = {})
			HittingStatSummary.where(conditions.merge(:playerID => self.playerID))
		end

		# Gets all the pitching stats for a player
		# @params [Hash] conditions for selecting stats
		# @return [Array<PitchingStatSummary>] pitching stats matching conditions
		def pitching_stats(conditions = {})
		end
	end
end