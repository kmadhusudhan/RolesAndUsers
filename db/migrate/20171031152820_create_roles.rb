class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.boolean :is_active

      t.timestamps
    end
  end
end
