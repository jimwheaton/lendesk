require 'optparse'
require 'ostruct'
require 'exifr/jpeg'
require 'csv'
require 'nokogiri'
require 'find'

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

      opts.on("--html", "Write HTML instead of CSV") do
        options[:html] = true
      end

      opts.on("-d", "--directory DIRECTORY", "Choose directory to process") do |d|
        options[:directory] = d
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
end

class ExifWriter
  Headers =  %i[filename latitude longitude]
  NA = 'NA'

  def get_file_meta(file)
    gps = EXIFR::JPEG.new(file).gps
    coords = gps.nil? ? { lat: NA, long: NA } : { lat: gps.latitude, long: gps.longitude }
    { filename: File.basename(file) }.merge(coords)
  end

  def write(filename, files)
    raise NotImplementedError.new("#{self.class.name}#write is an abstract method")
  end
end

class CsvWriter < ExifWriter
  def write(filename, files)
    CSV.open(filename, "w") do |csv|
      csv << Headers
      files.each do |file|
        csv << get_file_meta(file).values
      end
    end
  end
end

class HtmlWriter < ExifWriter
  def write(filename, files)
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
              files.each do |file|
                doc.tr {
                  get_file_meta(file).values.each { |val| doc.td val }
                }
              end
            }
          }
        }
      }
    end
    File.open(filename, 'w') { |f| f.puts builder.to_html }
  end
end

class Main
  def run(options)
    begin
      files = matches(options[:directory], options[:ext])

      if(options[:html])
        HtmlWriter.new.write(options[:filename], files)
      else
        CsvWriter.new.write(options[:filename], files)
      end
    rescue
      $stderr.print("Error: #{$!}\n")
      exit
    end
  end

  def matches(directory, extension)
    matches = []
    Find.find(directory) do |path|
      ext = File.extname(path)
      matches << path if ext && ext.downcase == extension
    end
    matches
  end

end

Main.new.run(Options.parse(ARGV))
