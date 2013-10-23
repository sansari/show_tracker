class AddCastToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :cast, :string
  end
end
