class CreateMarkups < ActiveRecord::Migration
  def change
    create_table :markups do |t|
      t.text :preprocessed
      t.text :postprocessed
      t.attachment :file
      t.timestamps
    end
  end
end
