class RenamePetsToProfiles < ActiveRecord::Migration
  def change
    rename_table :Pets, :Profiles
  end 
end