class Domain < ActiveRecord::Base
  has_many :nameserver
  has_many :glue

  has_one :owner
  has_one :administrator
  has_one :technical
  has_one :billing

  after_initialize do |domain|
    if domain.new_record?
      domain.build_owner
      domain.build_administrator
      domain.build_technical
      domain.build_billing
    end
  end

  def to_param
    self.name
  end
end
