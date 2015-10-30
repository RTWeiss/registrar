class Domain < ActiveRecord::Base
  belongs_to :user
  has_many :collaborations
  has_many :collaborators, through: :collaborations, source: :user

  has_many :nameservers
  has_many :glue

  has_one :owner
  has_one :admin
  has_one :billing
  has_one :tech

  validates_associated :owner, :admin, :billing, :tech

  after_initialize do |domain|
    if domain.new_record?
      domain.build_owner
      domain.build_admin
      domain.build_billing
      domain.build_tech
    end
  end

  # def initialize(params={})
  #   self.collaborators = []
  # end

  def to_param
    self.name
  end

  def to_xml(options = {})
    super include: [ :owner, :admin, :billing, :tech, :nameservers ]
  end

  def as_json(options = {})
    super include: [ :owner, :admin, :billing, :tech, :nameservers ]
  end
end
