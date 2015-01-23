module BaseballStats

	# Module to make it easy to define stats for a model
	module StatDefinitions

		# Add class variable to hold stat definitions
		def self.included(base)
			base.class.instance_eval do
				attr_accessor :stat_definitions
			end

			base.send(:extend, ClassMethods)
			base.send(:include, InstanceMethods)
		end

		# Class methods to define stats
		module ClassMethods

			# Pass in hash to define all the stats
			# @param [Hash] stats related to model
			def define_stats(stats = {})
				self.stat_definitions = stats

				stats.values.each do |attr|
					self.send(:attr_accessor, attr)
				end
			end
		end

		module InstanceMethods

			# Overrides intializer so that stats can be set correctly from abbreviations
			# @param [Hash] attributes of stat owner
			def initialize(attributes = {})
				stat_attributes = self.class.stat_definitions.keys # Get all stat attribute names

				# Set non-stat and stat fields
				attributes.each_pair do |key, value|
					unless stat_attributes.include?(key.to_sym)
						self.send("#{key}=", key.to_s == "yearID" ? value.to_i : value)
					else
						self.send("#{self.class.stat_definitions[key.to_sym]}=", value.to_i)
					end
				end
			end
		end
	end
end