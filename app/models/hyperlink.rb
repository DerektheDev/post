class Hyperlink < ActiveRecord::Base

  belongs_to :campaign

  def should_point_to
    # do some selenium magic here,
    # or check a 200 status on a header call
    # to the destination string
  end

end
