class Domain < ActiveRecord::Base
  has_many :nameserver
  has_many :glue
  has_one :owner
  has_one :administrator
  has_one :billing
  has_one :technical
end
