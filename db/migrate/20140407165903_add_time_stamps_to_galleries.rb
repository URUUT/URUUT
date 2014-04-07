class AddTimeStampsToGalleries < ActiveRecord::Migration
  def change
    add_timestamps :galleries
  end
end
