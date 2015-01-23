require "spec_helper"

include BaseballStats

describe FileReaderBase do

	describe "#parse_header" do
		before(:each) do
			@headers = FileReaderBase.parse_header(File.read('spec/files/test.csv'))
		end

		it "should return 4 header cells in an array: id, year, first name and last name" do
			@headers.should eq ["ID", "Year", "First Name", "Last Name"]
		end
	end

	describe "#read_file" do
		it "should read a file and return an array" do
			FileReaderBase.read_file('spec/files/test.csv').is_a?(Array).should be_true
		end

		it "should return an array with one item that is an hash of row items assigned to header keys" do
			data = FileReaderBase.read_file('spec/files/test.csv')
			data[0].is_a?(Hash).should be_true
			data[0]["ID"].should eq "15"
			data[0]["Year"].should eq "1984"
			data[0]["First Name"].should eq "Ryan"
			data[0]["Last Name"].should eq "Norman"
		end

		it "should return an array with one item that is an hash of row items assigned to header keys" do
			data = FileReaderBase.read_file('spec/files/multi_line_test.csv')
			data.size.should eq 2

			data[0].is_a?(Hash).should be_true
			data[0]["ID"].should eq "15"
			data[0]["Year"].should eq "1984"
			data[0]["First Name"].should eq "Ryan"
			data[0]["Last Name"].should eq "Norman"

			data[1].is_a?(Hash).should be_true
			data[1]["ID"].should eq "23"
			data[1]["Year"].should eq "1986"
			data[1]["First Name"].should eq "Jessica"
			data[1]["Last Name"].should eq "Garvey"
		end
	end

	describe "#store" do
		it "should raise an error since method is meant to be overridden by child class" do
			expect { FileReaderBase.store([]) }.to raise_exception
		end
	end

	describe "#parse" do
		it "should raise an error since store method is called and is meant to be overridden by child class" do
			expect { FileReaderBase.parse('spec/files/test.csv') }.to raise_exception
		end
	end
end