require "spec_helper"

describe StatsFileReader do

	before(:each) do
		HittingStatSummary.destroy_all
	end

	describe "#parse_header" do
		before(:each) do
			@headers = StatsFileReader.parse_header(File.read('spec/files/stats-test.csv'))
		end

		it "should return 4 header cells in an array: id, year, first name and last name" do
			@headers.should eq ["playerID","yearID","teamID","G","AB","R","H","2B","3B","HR","RBI","SB","CS"]
		end
	end

	describe "#read_file" do
		it "should read a file and return an array" do
			StatsFileReader.read_file('spec/files/stats-test.csv').is_a?(Array).should be_true
		end

		it "should return an array with one item that is an hash of row items assigned to header keys" do
			data = StatsFileReader.read_file('spec/files/stats-test.csv')
			data[0].is_a?(Hash).should be_true
			data[0]["playerID"].should eq "aardsda01"
			data[0]["yearID"].should eq "2012"
			data[0]["teamID"].should eq "NYA"
			data[0]["G"].should eq '1'
			data[0]["AB"].should eq ''
			data[0]["R"].should eq ''
			data[0]["H"].should eq ''
			data[0]["2B"].should eq ''
			data[0]["3B"].should eq ''
			data[0]["HR"].should eq ''
			data[0]["RBI"].should eq ''
			data[0]["SB"].should eq ''
			data[0]["CS"].should eq ''
		end

		it "should return an array with one item that is an hash of row items assigned to header keys" do
			data = StatsFileReader.read_file('spec/files/stats-test.csv')
			data.size.should eq 17

			data[0].is_a?(Hash).should be_true
			data[0]["playerID"].should eq "aardsda01"
			data[0]["yearID"].should eq "2012"
			data[0]["teamID"].should eq "NYA"
			data[0]["G"].should eq '1'
			data[0]["AB"].should eq ''
			data[0]["R"].should eq ''
			data[0]["H"].should eq ''
			data[0]["2B"].should eq ''
			data[0]["3B"].should eq ''
			data[0]["HR"].should eq ''
			data[0]["RBI"].should eq ''
			data[0]["SB"].should eq ''
			data[0]["CS"].should eq ''

			data[16].is_a?(Hash).should be_true
			data[16]["playerID"].should eq "abreubo01"
			data[16]["yearID"].should eq "2007"
			data[16]["teamID"].should eq "NYA"
			data[16]["G"].should eq '158'
			data[16]["AB"].should eq '605'
			data[16]["R"].should eq '123'
			data[16]["H"].should eq '171'
			data[16]["2B"].should eq '40'
			data[16]["3B"].should eq '5'
			data[16]["HR"].should eq '16'
			data[16]["RBI"].should eq '101'
			data[16]["SB"].should eq '25'
			data[16]["CS"].should eq '8'
		end
	end

	describe "#store" do
		it "should not raise an error since method has been overridden by child class" do
			expect { StatsFileReader.store([]) }.to_not raise_exception
		end

		it "should store a player in storage" do
			StatsFileReader.store([{
				:playerID => "abreubo01",
				:yearID => "2007",
				:teamID => "NYA",
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
			}])

			HittingStatSummary.all.size.should eq 1

			stats = HittingStatSummary.where(:playerID => "abreubo01")
			stats.first.playerID.should eq "abreubo01"
			stats.first.yearID.should eq 2007
			stats.first.teamID.should eq "NYA"
		end
	end
end