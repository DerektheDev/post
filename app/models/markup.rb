class Markup < ActiveRecord::Base

  belongs_to :campaign

  has_attached_file :file

  def self.permitted_filetypes
    [:html, :haml]
  end

end
