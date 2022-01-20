class ChangeAttendanceTypeFieldInProjects < ActiveRecord::Migration[6.1]
  def change
    change_column :projects, :attendance_type, :integer, using: 'attendance_type::integer', null: false
  end
end
