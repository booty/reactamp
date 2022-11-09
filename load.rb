# frozen_string_literal: true

require "nokogiri"
require "pry-byebug"
require "active_support/core_ext/string" # for snake_casing
require "sqlite3"
require "csv"

class Importer
  DB_FILE_NAME = "reactamp.db"
  COMPRESSED_LIBRARY_FILE_NAME = "Library.xml.bz2"
  UNCOMPRESSED_LIBRARY_FILE_NAME = "Library.xml"
  CSV_FILE_NAME = "Library.csv"
  IMPORT_RECORD_LIMIT = 9999999
  DATABASE_TABLE_NAME = "library"
  PROGRESS_EVERY_N_TRACKS = 5000

  def self.import
    library = get_library
    dump_csv(library)
    import_csv(library)
    # TODO: create db indexes on useful fields
  ensure
    clean_up_files
  end

  private_class_method def self.clean_up_files
    puts "Cleaning up..."
    `rm #{UNCOMPRESSED_LIBRARY_FILE_NAME}`
    `rm #{CSV_FILE_NAME}`
  end

  # returns decompressed library XML as a hash
  private_class_method def self.get_library
    puts "Decompressing xml..."
    `bzip2 --keep --decompress #{COMPRESSED_LIBRARY_FILE_NAME}`

    xml = Nokogiri::XML(File.open(UNCOMPRESSED_LIBRARY_FILE_NAME))

    # Find each dictionary item and loop through it
    xml.xpath("/plist/dict/dict/dict").take(IMPORT_RECORD_LIMIT).each_with_object(Array.new) do |node, list|
      hash     = {}
      last_key = nil
      puts "Parsed #{list.length}" if list.length.positive? && (list.length % PROGRESS_EVERY_N_TRACKS).zero?

      node.children.each do |child|
        next if child.blank?

        if child.name == "key"
          last_key = child.text
        else
          hash[last_key] = child.text
        end
      end
      list << hash # push on to our list
    end
  end

  private_class_method def self.db
    @@db ||= SQLite3::Database.new(DB_FILE_NAME)
  end

  private_class_method def self.create_table(library)
    puts "Creating or recreating database table... "
    db.execute("drop table if exists #{DATABASE_TABLE_NAME};")
    # fuck = <<~SQL
    #   create table #{DATABASE_TABLE_NAME} (
    #     #{fields(library)
    #         .map(&:underscore)
    #         .map { |x| "#{x.gsub(/\s/, '_')} varchar" }
    #         .join(",\n")
    #     }
    #   );
    # SQL
    # puts fuck
    # db.execute(fuck)
  end

  private_class_method def self.fields(library)
    @@fields ||= begin
        result = Set.new
        library.each do |x|
          result += x.keys
        end
        result = result.to_a
    end
  end

  private_class_method def self.fields_snake(library)
    @@fields_snake ||= begin
      fields(library)
        .map(&:underscore)
        .map { |x| x.gsub(/\s/, "_") }
    end
  end

  private_class_method def self.fields_header(library)
    result = fields_snake(library).dup
    result[0] = "id"
    result
  end

  private_class_method def self.dump_csv(library)
    print "Dumping CSV... "
    CSV.open(CSV_FILE_NAME, "w", col_sep: "\t") do |csv|
      csv << fields_header(library)
      library.each do |xml_track|
        row = []
        fields(library).each_with_index do |field, index|
        row << xml_track[fields(library)[index]]
      end
      csv << row
      end
    end
    puts "done"
  end

  private_class_method def self.import_csv(library)
    create_table(library)
    print "Importing to sqlite... "
    `sqlite3 reactamp.db  -separator $'\t' ".import Library.csv #{DATABASE_TABLE_NAME}"`
    puts "done"
  end
end

Importer.import