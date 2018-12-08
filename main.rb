require 'optparse'
require 'ostruct'
require 'exifr/jpeg'
require 'csv'
require 'nokogiri'
require_relative './find'

class Options
  def self.parse(args)
    options = OpenStruct.new
    options[:html] = false
    options[:directory] = "./"
    options[:ext] = ".jpg"

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: main.rb [options]"
      opts.separator ""
      opts.separator "Options:"

      opts.on("-f", "--filename FILE", "Filename to write") do |f|
        options[:filename] = f
      end

      opts.on("-h", "--html", "Write HTML instead of CSV") do
        options[:html] = true
      end

      opts.on("-d", "--directory [DIRECTORY]", "Choose directory to process") do |d|
        options[:directory] = d
      end

      opts.on("-h", "--help", "Help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end
end 

class Main

  Headers =  %i[filename latitude longitude]
  NA = 'NA'

  def self.run(options)
    files = Find.match("#{options[:directory]}") do |f| 
      ext = f[-4..f.size]
      ext && ext.downcase == options[:ext]
    end

    options[:html] ? self.write_html(options[:filename], files) : self.write_csv(options[:filename], files)
  end

  def self.write_csv(filename, files)
    CSV.open(filename, "w") do |csv|
      csv << Headers
      files.each do |file|
        gps = EXIFR::JPEG.new(file).gps
        coords = gps.nil? ? { lat: 'NA', long: 'NA' } : { lat: gps.latitude, long: gps.longitude }
        csv << [file, coords[:lat], coords[:long]]
      end
    end
  end

  def self.write_html(filename, files)
    builder = Nokogiri::HTML::Builder.new do |doc|
      doc.html {
        doc.body {
          doc.table {
            doc.thead {
              doc.tr {
                Headers.each { |header| doc.th header }
              }
            }
            doc.tbody {
              files.map(&self.get_file_meta).each do |meta|
                doc.tr {
                  Headers.each { |header| doc.td meta[header]}
                }
              end
            }
          }
        }
      }
    end
    builder.to_html
  end

  def self.get_file_meta(file)
    gps = EXIFR::JPEG.new(file).gps
    coords = gps.nil? ? { lat: NA, long: NA } : { lat: gps.latitude, long: gps.longitude }
    { filename: file }.merge(coords)
  end

end

Main.run(Options.parse(ARGV))
