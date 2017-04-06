class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :keyword
      t.boolean :title_flg
      t.boolean :sub_title_flg
      t.boolean :performer_flg
      t.boolean :description_flg
      t.boolean :information_flg
      t.boolean :twitter_flg

      t.timestamps null: false
    end
  end
end
