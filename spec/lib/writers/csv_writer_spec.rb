require "spec_helper"
require 'fakefs/spec_helpers'
require_relative "../../../lib/writers/csv_writer.rb"

describe "CsvWriter" do
  subject { CsvWriter.new }
  let(:files) { ['./spec/fixtures/no_gps_data.jpg', './spec/fixtures/has_gps_data.jpg'] }

  describe "#build_csv" do
    it 'should build a csv header row' do
      actual = subject.build_csv(['./spec/fixtures/has_gps_data.jpg'])
      expected = [:filename, :latitude, :longitude]
      expect(actual[0]).to match(expected)
    end

    it 'should add a row of GPS if image has location data' do
      actual = subject.build_csv(['./spec/fixtures/has_gps_data.jpg'])
      expected = ['has_gps_data.jpg', 50.09133333333333, -122.94566666666667]
      expect(actual[1]).to match(expected)
    end

    it 'should add a row of "NA" if image does not has location data' do
      actual = subject.build_csv(['./spec/fixtures/no_gps_data.jpg'])
      expected = ['no_gps_data.jpg', 'NA', 'NA']
      expect(actual[1]).to match(expected)
    end

    it 'should add a row for each image file' do
      actual = subject.build_csv(['./spec/fixtures/no_gps_data.jpg', './spec/fixtures/has_gps_data.jpg'])
      expected = [
        [:filename, :latitude, :longitude],
        ['no_gps_data.jpg', 'NA', 'NA'],
        ['has_gps_data.jpg', 50.09133333333333, -122.94566666666667]
      ]
      expect(actual).to match(expected)
    end
  end
end