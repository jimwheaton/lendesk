require 'csv'
require_relative './exif_writer'

##
# Writes a CSV file with GPS data for the specified image files
class CsvWriter < ExifWriter
  def write(filename, files)
    CSV.open(filename, "w") do |csv|
      # csv << Headers
      # files.each do |file|
      #   csv << get_file_meta(file).values
      # end
      
      build_csv(files).each do |row|
        csv << row
      end
    end
  end

  def build_csv(files)
    csv = []
    csv << Headers
    files.each do |file|
      csv << get_file_meta(file).values
    end
    csv
  end
end