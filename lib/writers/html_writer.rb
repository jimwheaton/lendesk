require 'nokogiri'
require_relative './exif_writer'

##
# Writes a HTML file with GPS data for the specified image files in table format
class HtmlWriter < ExifWriter

  def write(filename, files)
    html = build_html(files)
    File.open(filename, 'w') { |f| f.puts html }
  end

  # Build HTML document with GPS data for the specified files in table format
  def build_html(files)
    builder = Nokogiri::HTML::Builder.new do |doc|
      doc.html {
        doc.body {
          doc.table {
            build_table_header(doc)
            build_table_body(doc, files)
          }
        }
      }
    end

    builder.to_html
  end

  private
  
  # Builds header: |filename|latitude|longitude|
  def build_table_header(doc)
    doc.thead {
      doc.tr {
        Headers.each { |header| doc.th header }
      }
    }
  end

  # Adds a table row with GPS data for each file
  def build_table_body(doc, files)
    doc.tbody {
      files.each do |file|
        doc.tr {
          get_file_meta(file).values.each { |val| doc.td val }
        }
      end
    }
  end
end