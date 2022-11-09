# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


# Does the pristine database exist? If not, create it

# require_relative "import.rb"
# if File.exist?("db/#{Importer::DB_FILE_NAME}")
#   puts "Pristine database exists; cool."
# else
#   puts "Pristine database doesn't exist; will import."
#   Importer.import
# end

# # Rename the existing database
# puts "Renaming existing database if it exists
# `mv db/#{Rails.env}.sqlite3 db/#{Rails.env}.#{Time.current.iso8601.gsub(":","")}.sqlite3`

# # Copy over the pristine database

