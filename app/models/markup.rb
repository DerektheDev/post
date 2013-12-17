class Markup < ActiveRecord::Base

  # has_attached_file :file, styles: {medium: "300x300>", thumb: "100x100>"}, default_url: "/images/:style/missing.png"
  has_attached_file :file

  def self.permitted_filetypes
    [:html, :haml]
  end

end
