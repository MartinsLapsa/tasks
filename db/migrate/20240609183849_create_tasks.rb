class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.belongs_to :author, null: false, foreign_key: { to_table: :users }
      t.string :name
      t.text :description
      t.string :state
      t.date :deadline

      t.timestamps
    end
  end
end
