# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

campaign = Campaign.create

seed_styles_path = "app/assets/stylesheets/test.css"
seed_markup_path = "app/views/previews/markup/example.html"

seed_styles = Asset.create({
  campaign_id: campaign.id,
    extension: Compiler.get_ext(File.new seed_styles_path),
         file: File.new(seed_styles_path)
})
seed_markup = Asset.create({
  campaign_id: campaign.id,
    extension: Compiler.get_ext(File.new seed_markup_path),
         file: File.new(seed_markup_path)
})