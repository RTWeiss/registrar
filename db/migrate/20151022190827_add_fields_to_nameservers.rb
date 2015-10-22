class AddFieldsToNameservers < ActiveRecord::Migration
  def change
    add_column :nameservers, :order, :integer
    add_column :nameservers, :ip_address, :string
    add_reference :nameservers, :domain, index: true, foreign_key: true
  end
end
