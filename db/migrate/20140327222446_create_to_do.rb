class CreateToDo < ActiveRecord::Migration
  def change
    create_table :to_dos do |t|
      t.string :name
      t.string :description
      t.boolean :status
      t.timestamps
    end
  end
end
