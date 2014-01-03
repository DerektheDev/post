class Asset < ActiveRecord::Base
  
  belongs_to :campaign

  has_attached_file :file, default_url: "/files/:style/missing.png"
  has_attached_file :image, styles: {medium: '300x300', thumb: '100x100'}, default_url: "/images/:style/missing.png"

  # SCOPE
  # seed_styles[:asset_type]   = Asset.get_asset_type seed_styles[:extension]
  scope :stylesheets, lambda { where(extension: permitted_stylesheet_filetypes) }
  scope :markups,     lambda { where(extension: permitted_markup_filetypes)     }
  scope :images,      lambda { where(extension: permitted_image_filetypes)      }


  def self.permitted_filetypes
    (self.permitted_image_filetypes | self.permitted_markup_filetypes | self.permitted_stylesheet_filetypes)
  end

  def self.get_asset_type extension
    case extension
    when Asset.permitted_markup_filetypes
      :markup
    when Asset.permitted_stylesheet_filetypes
      :stylesheet
    when Asset.permitted_image_filetypes
      :image
    else
      :nonpermitted
    end
  end

  def self.app_relative_paths nokogiri_tree, campaign
    image_nodes = nokogiri_tree.css('img')
    image_nodes.each do |img|
      proper_file = campaign.assets.find_by image_file_name: img[:src]
      new_path = "#{proper_file.image.url[/[^?]+/]}"
      img[:src] = new_path
# imgsadfkjsf
    end
    nokogiri_tree
  end

private

  def self.permitted_markup_filetypes
    [:html, :haml]
  end

  def self.permitted_stylesheet_filetypes
    [:css, :scss, :sass, :jade]
  end

  def self.permitted_image_filetypes
    [:jpg, :jpeg, :png, :gif]
  end


end
