class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.references :campaign
      t.string     :extension
      t.attachment :file
      t.attachment :image
      t.timestamps
    end
  end
end
