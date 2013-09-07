class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, :symbol
      t.timestamps
    end

    create_table :taggings do |t|
      t.integer :tag_id, :entry_id
      t.timestamps
    end

    drop_table :stickings
    drop_table :stickers

    change_table(:entries) do |t|
      t.remove :int_flags
    end
  end
end