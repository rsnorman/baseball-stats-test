require "spec_helper"

describe FantasyScoring do
	describe "scoring_definitions" do
		it "should set home runs to 4 points" do
			FantasyScoring.scoring_definitions["HR"].should eq 4
		end

		it "should set runs batted in to 1 point" do
			FantasyScoring.scoring_definitions["RBI"].should eq 1
		end

		it "should set stolen bases to 1 point" do
			FantasyScoring.scoring_definitions["SB"].should eq 1
		end

		it "should set caught stealing to -1 point" do
			FantasyScoring.scoring_definitions["CS"].should eq -1
		end
	end

	describe "fantasy_score_for_hitter" do
		before(:each) do
			@player = Player.create({
				:playerID => "norman15",
				:birthYear => '1984',
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				})
		end

		after(:each) do
			Player.destroy_all
			HittingStatSummary.destroy_all
		end

		it "should return 0 if the player has zeroed out stats" do
			HittingStatSummary.create(:playerID => "norman15", :yearID => "2007", :teamID => "NYA",
					:HR => '0',
					:RBI => '0',
					:SB => '0',
					:CS => '0'
				)

			@player.fantasy_score_for_hitter(2007).should eq 0
		end

		it "should return 4 if the player has 1 homerun" do
			HittingStatSummary.create(:playerID => "norman15", :yearID => "2007", :teamID => "NYA",
					:HR => '1',
					:RBI => '0',
					:SB => '0',
					:CS => '0'
				)

			@player.fantasy_score_for_hitter(2007).should eq 4
		end

		it "should return 1 if the player has 1 run batted in" do
			HittingStatSummary.create(:playerID => "norman15", :yearID => "2007", :teamID => "NYA",
					:HR => '0',
					:RBI => '1',
					:SB => '0',
					:CS => '0'
				)

			@player.fantasy_score_for_hitter(2007).should eq 1
		end

		it "should return 1 if the player has 1 stolen base" do
			HittingStatSummary.create(:playerID => "norman15", :yearID => "2007", :teamID => "NYA",
					:HR => '0',
					:RBI => '0',
					:SB => '1',
					:CS => '0'
				)

			@player.fantasy_score_for_hitter(2007).should eq 1
		end

		it "should return -1 if the player has 1 time caught stealing" do
			HittingStatSummary.create(:playerID => "norman15", :yearID => "2007", :teamID => "NYA",
					:HR => '0',
					:RBI => '0',
					:SB => '0',
					:CS => '1'
				)

			@player.fantasy_score_for_hitter(2007).should eq -1
		end

		it "should return 5 if the player has 1 homerun, 1 rbi, 1 stolen base, and 1 time caught stealing" do
			HittingStatSummary.create(:playerID => "norman15", :yearID => "2007", :teamID => "NYA",
					:HR => '1',
					:RBI => '1',
					:SB => '1',
					:CS => '1'
				)

			@player.fantasy_score_for_hitter(2007).should eq 5
		end

		it "should return 0 if the player has not stats for the year" do
			@player.fantasy_score_for_hitter(2007).should eq 0
		end

	end
end