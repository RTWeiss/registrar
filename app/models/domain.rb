class Domain < ActiveRecord::Base
  has_many :nameserver
  has_many :glue

  has_one :owner
  has_one :admin
  has_one :billing
  has_one :tech

  after_initialize do |domain|
    if domain.new_record?
      domain.build_owner
      domain.build_admin
      domain.build_billing
      domain.build_tech
    end
  end

  def to_param
    self.name
  end

  def to_xml(options = {})
    super include: [ :owner, :admin, :billing, :tech ]
  end

  def as_json(options = {})
    super include: [ :owner, :admin, :billing, :tech ]
  end
end
