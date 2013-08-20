class CreateEntries < ActiveRecord::Migration
  def change
    create_table(:entries) do |t|
      t.string :body
      t.integer :int_type, :int_flags

      t.timestamps
    end
  end
end