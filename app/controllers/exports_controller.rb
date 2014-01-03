class ExportsController < ApplicationController
  def preflight_for_email_on_acid

    require 'zip'

    @campaign   = Campaign.find(session[:campaign_id])
    stylesheets = @campaign.assets.stylesheets
    markup_docs = @campaign.assets.markups
    images      = @campaign.assets.images

    master_zip_file_name = "#{@campaign.name.parameterize rescue 'campaign'}_#{DateTime.now.strftime("%d%m%Y%H%M%S")}"

    tmp_zip = Tempfile.new master_zip_file_name

    Zip::OutputStream.open(tmp_zip.path) do |z|
      markup_docs.each do |murecord|
        z.put_next_entry murecord.file_file_name
        mu_file = File.new("public#{strip_query murecord.file.url}")
        ss_file = File.new("public#{strip_query stylesheets.first.file.url}")
        content = Compiler::Markup.render mu_file, ss_file

        # z.print IO.read("public/#{strip_query(asset.file.url)}")
        z.print content.to_html
      end
    end

    send_file tmp_zip.path, type: 'application/zip',
                            disposition: :attachment,
                            filename: master_zip_file_name
    tmp_zip.close
  end
end
