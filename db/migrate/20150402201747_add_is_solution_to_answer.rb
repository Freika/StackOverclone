class AddIsSolutionToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :is_solution, :boolean, default: false
  end
end
