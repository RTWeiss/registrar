class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :organization
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code
      t.string :email
      t.string :phone_number

      t.string :type
      t.references :domain, index: true, foreign_key: true
    end
  end
end
