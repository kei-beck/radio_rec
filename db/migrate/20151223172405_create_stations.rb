class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :radiko_station_id
      t.string :radiru_station_id
      t.string :name
      t.string :ascii_name

      t.timestamps null: false
    end
  end
end
