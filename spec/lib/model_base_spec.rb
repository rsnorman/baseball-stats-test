require "spec_helper"

describe ModelBase do
	before(:each) do
		@inherited_model = Class.new(ModelBase) do
			set_indexes :playerID
			attr_accessor :playerID, :birthYear, :nameFirst, :nameLast
		end
	end

	after(:each) do
		@inherited_model.destroy_all
	end

	describe "#create" do
		it "should raise an error if there is no 'playerID' attribute present" do
			expect { @inherited_model.create({}) }.to raise_exception "Cannot be created if playerID is not present"
		end

		it "should create the player and store it for retrieval by 'playerID'" do
			@inherited_model.create({
				:playerID => "norman15",
				:birthYear => '1984',
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})

			@inherited_model.store.first.should_not be_nil
		end

		it "should return a player instance with all attributes set" do
			player = @inherited_model.create({
				:playerID => "norman15",
				:birthYear => "1984",
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})

			player.playerID.should eq "norman15"
			player.birthYear.should eq 1984
			player.nameFirst.should eq "Ryan"
			player.nameLast.should eq "Norman"
		end
	end

	describe "#all" do
		it "should return no players if none have been added" do
			@inherited_model.all.should eq []
		end

		it "should an array of players" do
			@inherited_model.create({
				:playerID => "norman15",
				:birthYear => "1984",
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})

			players = @inherited_model.all
			players.size.should eq 1
			players.first.playerID.should eq "norman15"
			players.first.birthYear.should eq 1984
			players.first.nameFirst.should eq "Ryan"
			players.first.nameLast.should eq "Norman"
		end
	end

	describe "#find_by_ indexed field" do
		it "should raise an error if player with playerID could not be found" do
			@inherited_model.find_by_playerID('badID').should be_nil
		end

		it "should return the player that matches the playerID" do
			instance = @inherited_model.create({
				:playerID => "norman15",
				:birthYear => "1984",
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})

			instance = @inherited_model.find_by_playerID('norman15')
			instance.is_a?(@inherited_model).should be_true
			instance.playerID.should eq "norman15"
			instance.birthYear.should eq 1984
			instance.nameFirst.should eq "Ryan"
			instance.nameLast.should eq "Norman"
		end
	end
end