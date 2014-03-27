class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.boolean :verified_type
      t.string :password
      t.date :dob
      t.integer :age
      t.string :profile_image
      t.boolean :gender
      t.string :faculty
      t.string :major
      t.integer :year
      t.integer :semester
      t.boolean :advising
      t.boolean :probation
      t.integer :failure_attempts
      t.integer :success_attempts

      t.references :student, polymorphic: true

      t.timestamps
    end
  end
end
