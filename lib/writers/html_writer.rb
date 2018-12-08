require 'nokogiri'
require_relative './exif_writer'

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