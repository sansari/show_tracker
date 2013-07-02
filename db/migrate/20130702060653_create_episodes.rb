class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :show_id
      t.integer :season
      t.integer :number
      t.string :name
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end
