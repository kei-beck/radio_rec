class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.integer :station_id
      t.string :start_time
      t.string :end_time
      t.string :air_time
      t.string :title
      t.string :sub_title
      t.string :performer
      t.string :description
      t.string :information

      t.timestamps null: false
    end
  end
end
