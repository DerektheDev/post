# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# seed_styles = %w[reset.css reset_1.css global.css global_1.scss california.css california_1.css global_head.css global_head.css california_head.css california_head_1.css]
seed_styles  = Dir.glob "lib/seed_files/seed_styles/*"
seed_markups = Dir.glob "lib/seed_files/seed_markups/*"

campaign = Campaign.create({name: "Seed Campaign"})

[seed_styles, seed_markups].each do |seed_file_dir|
  seed_file_dir.each do |file_path|
    file = File.new(file_path)

    Resource.create({
       campaign: campaign,
      extension: Compiler.get_ext(file),
           file: file
    })
  end
end

