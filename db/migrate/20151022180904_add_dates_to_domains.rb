class AddDatesToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :registration, :datetime
    add_column :domains, :expiry, :datetime
  end
end
