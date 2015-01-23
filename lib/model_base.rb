module BaseballStats

	# Base model to easily store and index instances in memory
	class ModelBase
		
		# Create class variables that are inherited but are new for inherited models
		class << self
    		attr_accessor :store, :indexes
  		end

		
		# Sets the indexes that make it a lot easier to search this model
		# @param [Array<Symbol>] args that are attributes that will be indexed
		def self.set_indexes(*args)
			self.indexes ||= HashWithIndifferentAccess.new

			# Loop through each index
			args.each do |index_name|

				# Set up new indexed hash to store positions of attributes in store array
				self.indexes[index_name] = HashWithIndifferentAccess.new

				# Create new methods to quickly find instances from indexed attribute
				self.class.instance_eval do

					# Find first instance by indexed field
      				define_method("find_by_#{index_name}") do |value|
      					self.send("find_all_by_#{index_name}", value).first
      				end

      				# Find all instances by indexed field
      				define_method("find_all_by_#{index_name}") do |value|
      					store_indices = self.indexes[index_name][value] || []
      					store_indices.collect{|x|  self.new(self.store[x])  }
      				end
    			end
			end
		end

		# Creates a new ModelBase instance and stores data in storage
		# @param [Hash] attributes of instance
		# @return [ModelBase] instance with attributes set
		def self.create(attributes = {})
			attributes = HashWithIndifferentAccess.new(attributes)

			self.store ||= []
			self.store << attributes

			# Add attributes to indexed hashes
			self.indexes && self.indexes.keys.each do |index|

				# Indexed fields must be included in attributes
				if attributes[index].nil?
					raise "Cannot be created if #{index} is not present" if attributes[index].to_s.empty?
				end

				self.indexes[index][attributes[index]] ||= []
				self.indexes[index][attributes[index]] << self.store.size - 1
			end
			

			self.new(attributes)
		end

		# Returns all instances that have been stored
		# @return [Array<ModelBase>] returns all instances
		def self.all
			!self.store.nil? ? self.store.collect{|x| self.new(x)} : []
		end


		# Destroys all items in storage
		def self.destroy_all
			self.store = []
			self.indexes && self.indexes.keys.each do |index|
				self.indexes[index] = HashWithIndifferentAccess.new
			end
		end

		# Finds instances based on conditions. Will find indexed fields much quicker than non-indexed fields.
		# @param [Hash] conditions for finding instances
		# @return [Array<ModelBase] array of matching instances
		def self.where(conditions)
			conditions = HashWithIndifferentAccess.new(conditions)

			store_indices = nil

			# Loop through each indexed attribute to see if we can speed searching for instances
			self.indexes.each_pair do |index, indices|

				# Find instances through indexed field if in conditions
				if conditions.has_key?(index)
					matching_indices = indices[conditions[index].to_s] || []

					# Add to indices or find matching indices already found
					store_indices = store_indices.nil? ? matching_indices : store_indices & matching_indices
				end

				conditions.delete(index)
			end

			# Only use instances matching indices found from indexed attributes
			unless store_indices.nil?
				instances = store_indices.collect{|x| self.store[x]}
			else
				instances = self.store
			end

			# Find all instances that match the conditions
			instances.select{|x| matching = true; conditions.each_pair{|k, v|  matching = matching && x[k] == v.to_s}; matching}.collect{|x| self.new(x)}
		end

		# Initializes a new model instance
		# @param [Hash] attributes of intance
		def initialize(attributes = {})
			attributes.each_pair do |key, value|
				self.send("#{key}=", key.to_s == "birthYear" ? value.to_i : value)
			end
		end
	end
end