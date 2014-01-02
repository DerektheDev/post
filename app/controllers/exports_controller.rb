class ExportsController < ApplicationController
  def preflight_for_email_on_acid

    require 'zip'

    @campaign   = Campaign.find(session[:campaign_id])
    asset_types = {
      stylesheets: @campaign.assets.stylesheets,
      markup_docs: @campaign.assets.markups,
           images: @campaign.assets.images
    }

    master_zip_file_name = "#{@campaign.name.parameterize rescue 'name'}_#{DateTime.now.strftime("%d%m%Y%H%M%S")}"

    tmp_zip = Tempfile.new master_zip_file_name

    Zip::OutputStream.open(tmp_zip.path) do |z|
      asset_types.each do |key, value|
        value.each do |asset|
          z.put_next_entry asset.file_file_name
          z.print IO.read("public/#{strip_query(asset.file.url)}")
        end
      end
    end

    send_file tmp_zip.path, type: 'application/zip',
                            disposition: :attachment,
                            filename: master_zip_file_name
    tmp_zip.close
  end
end
