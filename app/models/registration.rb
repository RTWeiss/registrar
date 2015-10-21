class Registration < ActiveRecord::Base
  belongs_to :domain

  def as_json(options={})
    {
      first_name: self.first_name,
      last_name: self.last_name,
      org_name: self.organization,
      address1: self.address1,
      address2: self.address2,
      address3: self.address3,
      city: self.city,
      state: self.state,
      postal_code: self.postal_code,
      country: self.country,
      phone: self.phone_number,
      email: self.email,
    }
  end
end
