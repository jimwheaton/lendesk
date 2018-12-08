require 'csv'
require_relative './exif_writer'

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