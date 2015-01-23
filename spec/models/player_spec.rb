require "spec_helper"

describe Player do
	after(:each) do
		Player.destroy_all
		HittingStatSummary.destroy_all
	end

	describe "#create" do
		it "should raise an error if there is no 'playerID' attribute present" do
			expect { Player.create({}) }.to raise_exception "Cannot be created if playerID is not present"
		end

		it "should create the player and store it for retrieval by 'playerID'" do
			Player.create({
				:playerID => "norman15",
				:birthYear => '1984',
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})

			Player.find("norman15").should_not be_nil
		end

		it "should not create the same player twice with the same 'playerID'" do
			Player.create({
				:playerID => "norman15",
				:birthYear => "1984",
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})

			expect {
				Player.create({
				:playerID => "norman15",
				:birthYear => "1984",
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})
				}.to raise_exception "Cannot create duplicate players with the same playerID"
		end

		it "should return a player instance with all attributes set" do
			player = Player.create({
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
			Player.all.should eq []
		end

		it "should an array of players" do
			Player.create({
				:playerID => "norman15",
				:birthYear => "1984",
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})

			players = Player.all
			players.size.should eq 1
			players.first.playerID.should eq "norman15"
			players.first.birthYear.should eq 1984
			players.first.nameFirst.should eq "Ryan"
			players.first.nameLast.should eq "Norman"
		end
	end

	describe "#find" do
		it "should raise an error if player with playerID could not be found" do
			expect { Player.find('badID') }.to raise_exception "Player could not be found with id of 'badID'"
		end

		it "should return the player that matches the playerID" do
			player = Player.create({
				:playerID => "norman15",
				:birthYear => "1984",
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})

			player = Player.find('norman15')

			player.is_a?(Player).should be_true
			player.playerID.should eq "norman15"
			player.birthYear.should eq 1984
			player.nameFirst.should eq "Ryan"
			player.nameLast.should eq "Norman"
		end
	end

	describe "#stats" do
		before(:each) do
			@player = Player.create({
				:playerID => "norman15",
				:birthYear => "1984",
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})

			HittingStatSummary.create(:playerID => "norman15", :yearID => "2007", :teamID => "NYA",
					:G => '158',
					:AB => '605',
					:R => '123',
					:H => '171',
					:"2B" => '40',
					:"3B" => '5',
					:HR => '16',
					:RBI => '101',
					:SB => '25',
					:CS => '8'
				)
		end

		it "should return no stats if there are none for a player" do
			HittingStatSummary.destroy_all
			@player.hitting_stats.should be_empty
		end

		it "should return stats that match the playerID" do


			@player.hitting_stats.should_not be_empty
			stat = @player.hitting_stats.first
			stat.games.should eq 158
			stat.at_bats.should eq 605
			stat.runs.should eq 123
			stat.hits.should eq 171
			stat.doubles.should eq 40
			stat.triples.should eq 5
			stat.home_runs.should eq 16
			stat.runs_batted_in.should eq 101
			stat.stolen_bases.should eq 25
			stat.caught_stealing.should eq 8
		end

		it "should return stats that match the playerID and yearID" do


			@player.hitting_stats(:yearID => 2007).should_not be_empty

			stat = @player.hitting_stats(:yearID => 2007).first
			stat.games.should eq 158
			stat.at_bats.should eq 605
			stat.runs.should eq 123
			stat.hits.should eq 171
			stat.doubles.should eq 40
			stat.triples.should eq 5
			stat.home_runs.should eq 16
			stat.runs_batted_in.should eq 101
			stat.stolen_bases.should eq 25
			stat.caught_stealing.should eq 8
		end
	end

	describe "#batting_average" do
		before(:each) do
			@player = Player.create({
				:playerID => "norman15",
				:birthYear => "1984",
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})

			HittingStatSummary.create(:playerID => "norman15", :yearID => "2007", :teamID => "NYA",
					:AB => '10',
					:H => '6'
				)

			HittingStatSummary.create(:playerID => "norman15", :yearID => "2008", :teamID => "NYA",
					:AB => '10',
					:H => '2'
				)
		end

		it "should return the batting average for the player for their whole career" do
			@player.batting_average.should eq 0.4
		end

		it "should return the batting average for the player for just one year" do
			@player.batting_average(2007).should eq 0.6
		end

		it "should return the batting average for the player for just one year even if they played on 2 teams" do
			HittingStatSummary.create(:playerID => "norman15", :yearID => "2008", :teamID => "OAK",
					:AB => '10',
					:H => '0'
				)
			@player.batting_average(2008).should eq 0.1
		end

		it "should return the zero for the batting average if the player did not play in that year" do
			@player.batting_average(2009).should eq 0
		end

		it "should return the zero for the batting average if the player has zeroed out stats" do
			HittingStatSummary.create(:playerID => "norman15", :yearID => "2009", :teamID => "OAK",
					:AB => '0',
					:H => '0'
				)

			@player.batting_average(2009).should eq 0
		end
	end

	describe "#slugging_percentage" do
		before(:each) do
			@player = Player.create({
				:playerID => "norman15",
				:birthYear => "1984",
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})

			HittingStatSummary.create(:playerID => "norman15", :yearID => "2007", :teamID => "NYA",
					:AB => '10',
					:H => '4',
					:"2B" => '1',
					:"3B" => '1',
					:HR => '1'
				)

			HittingStatSummary.create(:playerID => "norman15", :yearID => "2008", :teamID => "NYA",
					:AB => '10',
					:H => '2',
					:"2B" => '1',
					:"3B" => '1',
					:HR => '0'
				)
		end

		it "should return the batting average for the player for their whole career" do
			@player.slugging_percentage.should eq 0.75
		end

		it "should return the batting average for the player for just one year" do
			@player.slugging_percentage(2007).should eq 1.0
		end

		it "should return the batting average for the player for just one year even if they played on 2 teams" do
			HittingStatSummary.create(:playerID => "norman15", :yearID => "2008", :teamID => "OAK",
					:AB => '10',
					:H => '0',
					:"2B" => '0',
					:"3B" => '0',
					:HR => '0'
				)
			@player.slugging_percentage(2008).should eq 0.25
		end

		it "should return the zero for the batting average if the player did not play in that year" do
			@player.slugging_percentage(2009).should eq 0
		end

		it "should return the zero for the batting average if the player has zeroed out stats" do
			HittingStatSummary.create(:playerID => "norman15", :yearID => "2009", :teamID => "OAK",
					:AB => '0',
					:H => '0',
					:"2B" => '0',
					:"3B" => '0',
					:HR => '0'
				)

			@player.slugging_percentage(2009).should eq 0
		end
	end

	describe "#all_with_hitting_stats" do
		before :each do
			@player = Player.create({
				:playerID => "norman15",
				:birthYear => "1984",
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})
		end

		it "should return an empty array if no users have stats" do
			Player.all_with_hitting_stats.should be_empty
		end

		it "should return one player that has stats for them" do
			HittingStatSummary.create(:playerID => "norman15", :yearID => "2007", :teamID => "NYA",
					:AB => '10',
					:H => '4',
					:"2B" => '1',
					:"3B" => '1',
					:HR => '1'
				)

			Player.all_with_hitting_stats.first.playerID.should eq "norman15"
		end
	end
end