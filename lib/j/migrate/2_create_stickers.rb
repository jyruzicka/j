class CreateStickers < ActiveRecord::Migration
  def change
    create_table(:stickers) do |t|
      t.string :name, :html_reference
    
      t.timestamps
    end

    create_table(:stickings) do |t|
      t.integer :sticker_id, :entry_id

      t.timestamps
    end
  end
end