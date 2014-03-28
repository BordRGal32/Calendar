class InitialTables < ActiveRecord::Migration
  def change

    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :location
      t.date :start_date
      t.date :end_date
      t.boolean :status
    end
  end
end
