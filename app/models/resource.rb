class Resource < ActiveRecord::Base
  
  belongs_to :campaign

  has_attached_file :file#, default_url: "/files/:style/missing.png"
  has_attached_file :image, styles: {medium: '300x300', thumb: '100x100'}#, default_url: "/images/:style/missing.png"


  # attr_accessible :image_delete, :file_delete


  # SCOPE
  # seed_styles[:resource_type]   = Resource.get_resource_type seed_styles[:extension]
  scope :stylesheets, lambda { where(extension: permitted_stylesheet_filetypes) }
  scope :markups,     lambda { where(extension: permitted_markup_filetypes)     }
  scope :images,      lambda { where(extension: permitted_image_filetypes)      }


  def self.permitted_filetypes
    (self.permitted_image_filetypes | self.permitted_markup_filetypes | self.permitted_stylesheet_filetypes)
  end

  def self.get_resource_type extension
    extension = extension.to_sym
    if self.permitted_markup_filetypes.include? extension
      :markup
    elsif self.permitted_stylesheet_filetypes.include? extension
      :stylesheet
    elsif self.permitted_image_filetypes.include? extension
      :image
    else
      :nonpermitted
    end
  end

  def self.app_relative_paths nokogiri_tree, campaign
    image_nodes = nokogiri_tree.css('img')
    image_nodes.each do |img|
      new_path = if (proper_file = campaign.resources.find_by image_file_name: File.basename(img[:src]))
        "#{proper_file.image.url[/[^?]+/]}"
      else
        "resources/missing_img.jpg"
      end
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
