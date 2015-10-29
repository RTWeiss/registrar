class AddUserToDomains < ActiveRecord::Migration
  def change
    add_reference :domains, :user, index: true, foreign_key: true
  end
end
