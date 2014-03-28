class MemorableMigration < ActiveRecord::Migration
  def change

    create_table :notes do |t|
      t.string :name
      t.string :description
      t.references :memorable, polymorphic: true
      t.timestamps
    end

    add_column :events, :time, :time

  end
end
