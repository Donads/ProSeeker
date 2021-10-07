class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :description
      t.string :skills
      t.decimal :max_hourly_rate
      t.date :open_until
      t.string :attendance_type

      t.timestamps
    end
  end
end
