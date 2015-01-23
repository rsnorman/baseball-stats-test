require "spec_helper"

describe HittingStatSummary do
	before(:each) do
		HittingStatSummary.destroy_all
	end

	describe "#initialize" do
		it "should return a stat that matches the playerID" do
			stat = HittingStatSummary.new(:playerID => "abreubo01", :yearID => "2007", :teamID => "NYA",
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

			stat.should_not be_nil
			stat.playerID.should eq "abreubo01"
			stat.teamID.should eq "NYA"
			stat.yearID.should eq 2007
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

	describe "#find_all_by_playerID" do
		it "should return an empty array if there is no data" do
			HittingStatSummary.find_all_by_playerID("emptyID").should be_empty
		end

		it "should return an empty array if there is no data" do
			HittingStatSummary.create(:playerID => "abreubo01", :yearID => "2007", :teamID => "NYA",
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

			HittingStatSummary.find_all_by_playerID("abreubo01").size.should eq 1
		end
	end

	describe "#where" do
		it "should return an empty array if there is no data" do
			HittingStatSummary.where(:playerID => "emptyID").should be_empty
		end

		it "should return an empty array if there is not attribute" do
			HittingStatSummary.where(:bad_attribute => "emptyID").should be_empty
		end

		it "should return a stat that matches the playerID" do
			HittingStatSummary.create(:playerID => "abreubo01", :yearID => "2007", :teamID => "NYA")

			stat = HittingStatSummary.where(:playerID => "abreubo01").first

			stat.should_not be_nil
			stat.playerID.should eq "abreubo01"
			stat.teamID.should eq "NYA"
			stat.yearID.should eq 2007
		end

		it "should return a stat that matches the teamID" do
			HittingStatSummary.create(:playerID => "abreubo01", :yearID => "2007", :teamID => "NYA")

			stat = HittingStatSummary.where(:teamID => "NYA").first

			stat.should_not be_nil
			stat.playerID.should eq "abreubo01"
			stat.teamID.should eq "NYA"
			stat.yearID.should eq 2007

		end

		it "should return a stat that matches the yearID" do
			HittingStatSummary.create(:playerID => "abreubo01", :yearID => "2007", :teamID => "NYA")

			stat = HittingStatSummary.where(:yearID => 2007).first

			stat.should_not be_nil
			stat.playerID.should eq "abreubo01"
			stat.teamID.should eq "NYA"
			stat.yearID.should eq 2007

		end

		it "should return a stat that matches the playerID, yearID, and teamID" do
			HittingStatSummary.create(:playerID => "abreubo01", :yearID => "2007", :teamID => "NYA")

			stat = HittingStatSummary.where(:playerID => "abreubo01", :yearID => 2007, :teamID => "NYA").first

			stat.should_not be_nil
			stat.playerID.should eq "abreubo01"
			stat.teamID.should eq "NYA"
			stat.yearID.should eq 2007

		end

		it "should not return a stat that matches the playerID, yearID, but not the teamID" do
			HittingStatSummary.create(:playerID => "abreubo01", :yearID => "2007", :teamID => "NYA")

			stat = HittingStatSummary.where(:playerID => "abreubo01", :yearID => 2007, :teamID => "OAK").first

			stat.should be_nil

		end
  	end

  	describe "#player" do
  		it "should return the player tied to the stat" do
  			Player.create(:playerID => "abreubo01", :nameFirst => 'Ryan', :nameLast => 'Norman')
  			stat = HittingStatSummary.create(:playerID => "abreubo01", :yearID => "2007", :teamID => "NYA")

  			stat.player.name.should eq "Ryan Norman"
  		end
  	end
end