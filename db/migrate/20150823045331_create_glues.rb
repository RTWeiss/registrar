class CreateGlues < ActiveRecord::Migration
  def change
    create_table :glues do |t|
      t.string :name
      t.string :ipv4
      t.string :ipv6
    end
  end
end
