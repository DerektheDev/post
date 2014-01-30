class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :mpx_client_id
      t.integer :mpx_site_id
      t.timestamps
    end
  end
end
