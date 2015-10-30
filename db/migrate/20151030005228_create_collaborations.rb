class CreateCollaborations < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|
      t.references :user, index: true, foreign_key: true
      t.references :domain, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
