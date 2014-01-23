class AddCachingToResources < ActiveRecord::Migration
  def change
    change_table :resources do |t|
      t.text    :cached_compilation, limit: 64.kilobytes + 1
      t.boolean :cache_valid, default: 0
    end
  end
end
