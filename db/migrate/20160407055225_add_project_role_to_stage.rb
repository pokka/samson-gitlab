class AddProjectRoleToStage < ActiveRecord::Migration
  def change
    change_table :stages do |t|
      t.integer :role_id, default: 0
    end
  end
end
