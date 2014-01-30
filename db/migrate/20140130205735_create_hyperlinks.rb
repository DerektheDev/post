class CreateHyperlinks < ActiveRecord::Migration
  def change
    create_table :hyperlinks do |t|
      t.references :campaign
      t.integer :mpx_link_id
      t.string :destination # where does it point after redirect?
      t.timestamps
    end
  end
end
