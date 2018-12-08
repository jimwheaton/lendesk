Gem::Specification.new do |s|
  s.name        = 'exif'
  s.version     = '0.1.0'
  s.date        = '2018-12-10'
  s.summary     = "EXIF extractor"
  s.description = "Writes image EXIF data to CSV or HTML files"
  s.authors     = ["Jim Wheaton"]
  s.email       = 'jimwheaton@gmail.com'
  s.files       = ["lib/exif.rb", "lib/writers/exif_writer.rb", "lib/writers/csv_writer.rb", "lib/writers/html_writer.rb"]
  s.homepage    = 'https://github.com/jimwheaton/lendesk'
  s.license     = 'MIT'
  s.executables = ['exif']
end