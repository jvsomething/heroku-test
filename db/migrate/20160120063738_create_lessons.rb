class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.references :schedule, index: true, foreign_key: true
      t.references :student, index: true, foreign_key: true
      t.references :subscription, index: true, foreign_key: true
      t.integer :lesson_status
      t.date :lesson_date

      t.timestamps null: false
    end
  end
end
