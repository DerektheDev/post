class Campaign < ActiveRecord::Base

  has_many :markups
  has_many :stylesheets
  has_many :images

end
