class RemoveEpisodeCasts < ActiveRecord::Migration
  def change
    remove_column :episodes, :cast
  end
end
