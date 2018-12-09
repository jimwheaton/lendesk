# Lendesk EXIF GPS metadata utility

Writes EXIF GPS metadata to a .csv or .html file

### Building and installing the gem

1. `bundle install`
2. `gem build exif.gemspec`
3. `gem install exif-0.1.0.gem`

### Running from the command line

`./bin/exif`

### Run specs

`rspec`

### Examples

Process images in current directory and output CSV to an auto-generated `exif_data_<timestamp>.csv` file:

```
./bin/exif
```

Process images in current directory and output CSV to `my_vacay.csv`:

```
./bin/exif -f my_vacay.csv
```

Process images in `~/vacation_pics` and output CSV to `my_vacay.csv`:

```
./bin/exif -f my_vacay.csv -d ~/vacation_pics
```

Process images in `~/vacation_pics` and output an HTML table to `my_vacay.html`:

```
./bin/exif -f my_vacay.html -d ~/vacation_pics --html
```

#### Options

```
-h --help                       # prints available options
-d --directory path/to/images   # path to the images to process. Defaults to current directory
-f --filename my_data.csv       # filename to output. Defaults to exif_data_<timestamp>.(csv|html)
--html                          # output HTML instead of CSV
```
