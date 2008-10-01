class AddTitle < ActiveRecord::Migration
  def self.up
    add_column :smers, :title, :string, :limit => 20, :null => false
  end

  def self.down
    remove_column :smers, :title
  end
end
