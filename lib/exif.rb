require 'optparse'
require 'ostruct'
require 'find'
require_relative './writers/exif_writer'
require_relative './writers/csv_writer'
require_relative './writers/html_writer'

##
# Extracts and writes EXIF GPS data for JPG images to a CSV or HTML file
class Exif

  # Main entry point
  def run(args)
    Process.setproctitle('LenDesk EXIF GPS Writer')
    options = parse_args(args)

    begin
      files = matches(options[:directory], options[:ext])

      if(options[:html])
        HtmlWriter.new.write(options[:filename], files)
      else
        CsvWriter.new.write(options[:filename], files)
      end
    rescue
      $stderr.print("Error: #{$!}\n")
      exit(1)
    end
  end

  # Parse command line arguments
  def parse_args(args)
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

      opts.on("-d", "--directory DIRECTORY", "Image directory to process") do |d|
        options[:directory] = d
      end

      opts.on("--html", "Output HTML instead of CSV") do
        options[:html] = true
      end

      opts.on("-h", "--help", "Help") do
        puts opts
        exit
      end
    end

    begin
      opt_parser.parse!(args)
    rescue OptionParser::ParseError
      $stderr.print("Argument Error: #{$!}\n")
      exit
    end

    # set default filename if not supplied
    unless options[:filename]
      ext = options[:html] ? 'html' : 'csv'
      options[:filename] = "exif_data_#{Time.now.strftime("%s")}.#{ext}"
    end

    options
  end

  # Recursively searches the specified directory for files matching an extension
  # Returns an array of fully qualified filenames
  def matches(directory, extension)
    matches = []
    Find.find(directory) do |path|
      ext = File.extname(path)
      matches << path if ext && ext.downcase == extension
    end
    matches
  end

end
