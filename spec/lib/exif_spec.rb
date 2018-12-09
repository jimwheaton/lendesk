require 'spec_helper'
require_relative '../../lib/exif'
require_relative '../../lib/writers/csv_writer'
require_relative '../../lib/writers/html_writer'

describe 'Exif' do
  subject { Exif.new }
  let(:filename) { 'my_filename.csv' }
  let(:files) { ['./spec/fixtures/has_gps_data.jpg', './spec/fixtures/no_gps_data.jpg'] }

  describe '#parse_args' do
    it 'should use default values if no arguments are specified' do
      options = subject.parse_args([])
      expect(options[:filename]).to match(/^exif_data_.*/)
      expect(options[:directory]).to eq('./')
      expect(options[:ext]).to eq('.jpg')
      expect(options[:html]).to be false
    end

    it 'should set options to specified arguemnts' do
      args = ['-f', filename, '-d', 'some/path', '--html']
      options = subject.parse_args(args)

      expect(options[:filename]).to eq(args[1])
      expect(options[:directory]).to eq(args[3])
      expect(options[:html]).to be true
    end
  end

  describe '#matches' do
    it 'should return array of .jpgs recursively' do
      matches = subject.matches('./spec', '.jpg')
      expect(matches).to match(files)
    end
  end

  describe '#run' do
    it 'should write a CSV file by default' do
      args = ['-f', filename]
      csv_writer = instance_double(CsvWriter)
      expect(csv_writer).to receive(:write).with(filename, files)
      expect(CsvWriter).to receive(:new).and_return(csv_writer)

      subject.run(args)
    end

    it 'should write a HTML file if --html is specified' do
      args = ['-f', filename, '--html']
      html_writer = instance_double(HtmlWriter)
      expect(html_writer).to receive(:write).with(filename, files)
      expect(HtmlWriter).to receive(:new).and_return(html_writer)

      subject.run(args)
    end
  end
end
