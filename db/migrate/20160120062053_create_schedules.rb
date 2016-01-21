class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :teacher, index: true, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :schedule_status

      t.timestamps null: false
    end
  end
end
