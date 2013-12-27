class Image < ActiveRecord::Base

  belongs_to :campaign

  # has_attached_file :file, styles: {medium: "300x300>", thumb: "100x100>"}, default_url: "/images/:style/missing.png"
  has_attached_file :file, styles: {medium: '300x300', thumb: '100x100'}, default_url: "/images/:style/missing.png"

  def self.permitted_filetypes
    [:jpg, :jpeg, :png, :gif]
  end

end
