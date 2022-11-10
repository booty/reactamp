# frozen_string_literal: true

class Importer
  PRISTINE_DB_FILE = "#{Rails.root}/db/reactamp-pristine.sqlite3"
  COMPRESSED_LIBRARY_FILE = "#{Rails.root}/db/Library.xml.bz2"
  UNCOMPRESSED_LIBRARY_FILE = "#{Rails.root}/db/Library.xml"
  CSV_FILE_NAME = "#{Rails.root}/db/Library.csv"
  IMPORT_RECORD_LIMIT = 9999999
  DATABASE_TABLE_NAME = "tracks"
  PROGRESS_EVERY_N_TRACKS = 5000

  def self.pristine_exists?
    File.file?(PRISTINE_DB_FILE)
  end

  # Decompresses XML, dumps to CSV, rebuilds reactamp-pristine.sqlite3
  def self.recreate_pristine
    library = get_library
    dump_csv(library)
    import_csv(library)
  ensure
    clean_up_files
  end

  def self.load_tracks_from_pristine
    db_path = "#{Rails.root}/db/#{Rails.env}.sqlite3"
    print "Env is #{Rails.env}; will load tracks into #{db_path}... "
    db = SQLite3::Database.new(db_path)
    db.execute "attach \"#{Rails.root}/db/reactamp-pristine.sqlite3\" as source;"
    db.execute "insert into main.tracks select * from source.tracks where source.tracks.id not in (select id from main.tracks)"
    db.execute "vacuum;"
    db.execute "detach source;"
    puts "done"
  end

  private_class_method def self.execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end

  private_class_method def self.clean_up_files
    print "Cleaning up... "
    `rm #{UNCOMPRESSED_LIBRARY_FILE}`
    `rm #{CSV_FILE_NAME}`
    puts "done"
  end

  # returns decompressed library XML as a hash
  private_class_method def self.get_library
    print "Decompressing xml... "
    `bzip2 --keep --decompress #{COMPRESSED_LIBRARY_FILE}`
    puts "done"

    xml = Nokogiri::XML(File.open(UNCOMPRESSED_LIBRARY_FILE))

    # Find each dictionary item and loop through it
    print "Parsing and loading xml..."
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
    @@db ||= SQLite3::Database.new(PRISTINE_DB_FILE)
  end

  private_class_method def self.create_table(library)
    puts "Creating or recreating database table... "
    db.execute("drop table if exists #{DATABASE_TABLE_NAME};")
    # This is unnecessary, as Sqlite3's CSV import will create
    # the table and column names based on the header row in the CSV.
    # However, might want to reinstate this to enforce proper column
    # types and create indexes here, rather than doing it later
    # thru migrations
    #
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
    `sqlite3 #{PRISTINE_DB_FILE} -separator $'\t' ".import #{CSV_FILE_NAME} #{DATABASE_TABLE_NAME}"`
    puts "done"
  end
end

desc "Recreate pristine library database from XML"
namespace :db do
  task :recreate_pristine do
    Importer.recreate_pristine
  end

  task :load_tracks_from_pristine do
    Importer.load_tracks_from_pristine
  end
end
