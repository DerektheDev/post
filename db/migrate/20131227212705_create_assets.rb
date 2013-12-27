class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :campaign
      t.string     :extension
      t.attachment :file
      t.attachment :image
      t.timestamps
    end
  end
end
