class CreateLecturers < ActiveRecord::Migration
  def change
    create_table :lecturers do |t|
      t.string :name
      t.string :degree

      t.timestamps
    end
  end
end
