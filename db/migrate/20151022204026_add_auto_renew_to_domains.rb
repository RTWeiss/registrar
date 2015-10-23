class AddAutoRenewToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :autorenew, :boolean
  end
end
