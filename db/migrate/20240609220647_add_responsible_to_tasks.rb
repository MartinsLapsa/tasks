class AddResponsibleToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :responsible, null: false, foreign_key: { to_table: :users }
  end
end
