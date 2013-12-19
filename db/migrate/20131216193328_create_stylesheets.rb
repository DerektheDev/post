class CreateStylesheets < ActiveRecord::Migration
  def change
    create_table :stylesheets do |t|
      t.text :preprocessed
      t.text :postprocessed
      t.attachment :file
      t.timestamps
    end
  end
end