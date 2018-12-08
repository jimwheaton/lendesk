require 'exifr/jpeg'

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
