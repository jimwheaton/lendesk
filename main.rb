require 'optparse'
require 'ostruct'
require 'exifr/jpeg'
require 'csv'
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
  def self.run(options)
    files = Find.match("#{options[:directory]}") do |f| 
      ext = f[-4..f.size]
      ext && ext.downcase == options[:ext]
    end

    self.write_exifr(options[:filename], files)
  end

  def self.write_exifr(filename, files)
    CSV.open(filename, "w") do |csv|
      csv << ['filename', 'latitude', 'longitude']
      files.each do |file|
        gps = EXIFR::JPEG.new(file).gps
        coords = gps.nil? ? { lat: 'NA', long: 'NA' } : { lat: gps.latitude, long: gps.longitude }
        csv << [file, coords[:lat], coords[:long]]
      end
    end
  end

end

Main.run(Options.parse(ARGV))
