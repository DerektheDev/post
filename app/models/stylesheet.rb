class Stylesheet < ActiveRecord::Base

  belongs_to :campaign
  
  has_attached_file :file

  def self.permitted_filetypes
    [:css, :scss, :sass, :jade]
  end

end
