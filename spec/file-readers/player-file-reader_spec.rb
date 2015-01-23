require "spec_helper"

describe PlayerFileReader do

	before(:each) do
		Player.destroy_all
	end

	describe "#parse_header" do
		before(:each) do
			@headers = PlayerFileReader.parse_header(File.read('spec/files/player-test.csv'))
		end

		it "should return 4 header cells in an array: id, year, first name and last name" do
			@headers.should eq ["playerID", "birthYear", "nameFirst", "nameLast"]
		end
	end

	describe "#read_file" do
		it "should read a file and return an array" do
			PlayerFileReader.read_file('spec/files/player-test.csv').is_a?(Array).should be_true
		end

		it "should return an array with one item that is an hash of row items assigned to header keys" do
			data = PlayerFileReader.read_file('spec/files/player-test.csv')
			data[0].is_a?(Hash).should be_true
			data[0]["playerID"].should eq "aaronha01"
			data[0]["birthYear"].should eq "1934"
			data[0]["nameFirst"].should eq "Hank"
			data[0]["nameLast"].should eq "Aaron"
		end

		it "should return an array with one item that is an hash of row items assigned to header keys" do
			data = PlayerFileReader.read_file('spec/files/player-test.csv')
			data.size.should eq 18

			data[0].is_a?(Hash).should be_true
			data[0].is_a?(Hash).should be_true
			data[0]["playerID"].should eq "aaronha01"
			data[0]["birthYear"].should eq "1934"
			data[0]["nameFirst"].should eq "Hank"
			data[0]["nameLast"].should eq "Aaron"

			data[1].is_a?(Hash).should be_true
			data[17].is_a?(Hash).should be_true
			data[17]["playerID"].should eq "aberal01"
			data[17]["birthYear"].should eq "1927"
			data[17]["nameFirst"].should eq "Al"
			data[17]["nameLast"].should eq "Aber"
		end
	end

	describe "#store" do
		it "should not raise an error since method has been overridden by child class" do
			expect { PlayerFileReader.store([]) }.to_not raise_exception
		end

		it "should store a player in storage" do
			PlayerFileReader.store([{
				:playerID => 'norman15',
				:birthYear => '1984',
				:nameFirst => 'Ryan',
				:nameLast => 'Norman'
				}])

			player = Player.find('norman15')
			player.playerID.should eq 'norman15'
			player.birthYear.should eq 1984
			player.nameFirst.should eq 'Ryan'
			player.nameLast.should eq 'Norman'
		end
	end

	describe "#parse" do
		it "should not raise an error since store method has been overridden by child class" do
			expect { PlayerFileReader.parse('spec/files/player-test.csv') }.to_not raise_exception
		end

		it "should store a player in storage read from file" do
			PlayerFileReader.parse('spec/files/player-test.csv')

			players = Player.all

			players.size.should eq 18

			player1 = Player.find "aaronha01"
			player1.birthYear.should eq 1934
			player1.nameFirst.should eq "Hank"
			player1.nameLast.should eq "Aaron"

			player17 = Player.find "aberal01"
			player17.birthYear.should eq 1927
			player17.nameFirst.should eq "Al"
			player17.nameLast.should eq "Aber"
		end
	end
end