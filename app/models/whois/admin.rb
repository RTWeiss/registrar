class Admin < Registration
  belongs_to :domain, foreign_key: 'domain_id'
end