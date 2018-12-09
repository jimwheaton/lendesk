require "spec_helper"
require "rspec-html-matchers"
require 'fakefs/spec_helpers'
require_relative "../../../lib/writers/html_writer.rb"

describe "HtmlWriter" do
  include RSpecHtmlMatchers
  

  subject { HtmlWriter.new }
  let(:filename) { "/tmp/gps.html" }
  let(:files) { ['./spec/fixtures/no_gps_data.jpg', './spec/fixtures/has_gps_data.jpg'] }

  # describe "#write" do
  #   include FakeFS::SpecHelpers
  #   it 'should write the html to a file' do
  #     FakeFS do
  #       config = File.expand_path('../../fixtures', __FILE__)
  #       FakeFS::FileSystem.clone(config)
        
  #       subject.write(filename, ['./spec/fixtures/has_gps_data.jpg'])
  #       File.exits?(filename).should be_true
  #     end
  #   end
  # end

  describe "#build_html" do
    it 'should build table header' do
      html = subject.build_html(['./spec/fixtures/has_gps_data.jpg'])
      expect(html).to have_tag('table') do
        with_tag 'thead' do
          with_tag 'tr' do
            with_tag 'th', :text => 'filename'
            with_tag 'th', :text => 'latitude'
            with_tag 'th', :text => 'longitude'
          end
        end
      end
    end

    it 'should add GPS data to tbody if image has location data' do
      html = subject.build_html(['./spec/fixtures/has_gps_data.jpg'])
      expect(html).to have_tag('table') do
        with_tag 'tbody' do
          with_tag 'tr' do
            with_tag 'td', :text => 'has_gps_data.jpg'
            with_tag 'td', :text => '50.09133333333333'
            with_tag 'td', :text => '-122.94566666666667'
          end
        end
      end
    end

    it 'should add "NA" to tbody if image has does not have location data' do
      html = subject.build_html(['./spec/fixtures/no_gps_data.jpg'])
      expect(html).to have_tag('table') do
        with_tag 'tbody' do
          with_tag 'tr' do
            with_tag 'td', :text => 'no_gps_data.jpg'
            with_tag 'td', :text => 'NA'
            with_tag 'td', :text => 'NA'
          end
        end
      end
    end

    it 'should add a row for each image file' do
      html = subject.build_html(['./spec/fixtures/no_gps_data.jpg', './spec/fixtures/has_gps_data.jpg'])
      expect(html).to have_tag('table') do
        with_tag 'tbody' do
          with_tag 'tr' do
            with_tag 'td', :text => 'no_gps_data.jpg'
            with_tag 'td', :text => 'NA'
            with_tag 'td', :text => 'NA'
          end
          with_tag 'tr' do
            with_tag 'td', :text => 'has_gps_data.jpg'
            with_tag 'td', :text => '50.09133333333333'
            with_tag 'td', :text => '-122.94566666666667'
          end
        end
      end
    end
  end
end