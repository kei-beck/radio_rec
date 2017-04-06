class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :station_id
      t.integer :program_id
      t.string :start_time
      t.string :air_time
      t.string :title
      t.string :performer
      t.integer :status

      t.timestamps null: false
    end
  end
end
