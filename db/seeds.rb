# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

styles_file = File.new "app/assets/stylesheets/test.css"
markup_file = File.new "app/views/compiler/markup/example.html"

campaign = Campaign.create

seed_styles = Stylesheet.create({
   campaign_id: 1,
          file: styles_file,
  preprocessed: styles_file.read
})

seed_markup = Markup.create({
   campaign_id: 1,
          file: markup_file,
  preprocessed: markup_file.read
})
