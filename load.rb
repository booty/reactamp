# frozen_string_literal: true

require "nokogiri"
require "pry-byebug"
require "active_support/core_ext/string" # for snake_casing
require "sqlite3"
require "csv"

puts "Decompressing..."
`bzip2 --keep --decompress Library.xml.bz2`

xml = Nokogiri::XML(File.open("Library.xml"))

list = []

# Find each dictionary item and loop through it
xml.xpath("/plist/dict/dict/dict").take(3).each_with_index do |node, parent_index|
  hash     = {}
  last_key = nil
  puts "Parsed #{parent_index}" if (parent_index % 100).zero?

  # Stuff the key value pairs in to hash.  We know a key is followed by
  # a value, so we'll just skip blank nodes, save the key, then when we
  # find the value, add it to the hash
  node.children.each_with_index do |child, child_index|
    puts "    Parsed #{child_index}" if child_index.positive? && (child_index % 100).zero?
    next if child.blank? # Don't care about blank nodes

    if child.name == 'key'
      # Save off the key
      last_key = child.text
    else
      # Use the key we saved
      hash[last_key] = child.text
    end
  end

  list << hash # push on to our list
end


# make da table

fields = Set.new
list.take(3).each { |x| fields += x.keys }
fields_snake = fields
  .map(&:underscore)
  .map { |x| x.gsub(/\s/, "_") }

# list.each { |x| fields += x.keys }
# fuck = <<~SQL.squish
#   drop table if exists tracks;
#   create table tracks (
#     #{fields
#         .map(&:underscore)
#         .map { |x| "#{x.gsub(/\s/, '_')} varchar" }
#         .join(",\n")
#     }
#   );
# SQL

# db.execute(fuck)
#

fields = fields.to_a
# puts "fields: #{fields}"
# puts "fields_snake: #{fields_snake}"

CSV.open("yourmom.csv", "w", col_sep: "\t") do |csv|
  csv << fields_snake
  list.take(3).each do |xml_track|
    row = []
    fields.each_with_index do |field, index|
      # puts "   field: #{field} index: #{index}"
      # binding.pry
      row << xml_track[fields[index]]
    end
    # binding.pry
    csv << row
  end
end

`rm Library.xml`
