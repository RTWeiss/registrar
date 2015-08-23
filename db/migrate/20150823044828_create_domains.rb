class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.boolean :lock
      t.boolean :privacy
      t.string :epp

      t.timestamps null: false
    end
  end
end
