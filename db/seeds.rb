# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

seed_styles_path   = "app/assets/stylesheets/test.css"
seed_markup_path   = "app/views/resources/markup/example.html"
seed_markup_path_2 = "app/views/resources/markup/example.haml"

campaign = Campaign.create({name: "Seed Campaign"})

seed_styles = Resource.create({
     campaign: campaign,
    extension: Compiler.get_ext(File.new seed_styles_path),
         file: File.new(seed_styles_path)
})
seed_markup = Resource.create({
     campaign: campaign,
    extension: Compiler.get_ext(File.new seed_markup_path),
         file: File.new(seed_markup_path)
})
seed_markup_2 = Resource.create({
     campaign: campaign,
    extension: Compiler.get_ext(File.new seed_markup_path_2),
         file: File.new(seed_markup_path_2)
})


%w[reset.css reset_1.css global.css global_1.css california.css california_1.css global_head.css global_head.css california_head.css california_head_1.css].each do |ss|
  Resource.create({
    file_file_name: ss,
          campaign: campaign,
         extension: ss.split('.').last.to_sym
  })
end
