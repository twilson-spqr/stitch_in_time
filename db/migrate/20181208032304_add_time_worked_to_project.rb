class AddTimeWorkedToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :time_worked, :integer
  end
end
