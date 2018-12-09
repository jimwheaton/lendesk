require 'exifr/jpeg'

##
# Base class for writing EXIF GPS data
class ExifWriter
  HEADERS = %i[filename latitude longitude].freeze
  NA = 'NA'.freeze

  # Extracts GPS data from an image
  # Returns a hash { filename, lat, long }
  def get_file_meta(file)
    gps = EXIFR::JPEG.new(file).gps
    coords = gps.nil? ? { lat: NA, long: NA } : { lat: gps.latitude, long: gps.longitude }
    { filename: File.basename(file) }.merge(coords)
  end
end
