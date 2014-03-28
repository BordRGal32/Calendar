class ChangeColumnType < ActiveRecord::Migration
  def change
    remove_column :to_dos, :status, :boolean
    add_column :to_dos, :status, :string
  end
end
