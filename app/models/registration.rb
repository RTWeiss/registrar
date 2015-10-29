class Registration < ActiveRecord::Base
  belongs_to :domain

  validates_presence_of :first_name, :last_name, :organization, :address1,
    :city, :state, :postal_code, :country, :phone_number, :email

  def as_json(options={})
    {
      first_name:   self.first_name,
      last_name:    self.last_name,
      org_name:     self.organization,
      address1:     self.address1,
      address2:     self.address2,
      address3:     self.address3,
      city:         self.city,
      state:        self.state,
      postal_code:  self.postal_code,
      country:      self.country,
      phone:        self.phone_number,
      email:        self.email
    }
  end

  def from_json(options={})
    self.first_name =   options['first_name']
    self.last_name =    options['last_name']
    self.organization = options['org_name']
    self.address1 =     options['address1']
    self.address2 =     options['address2']
    self.address3 =     options['address3']
    self.city =         options['city']
    self.state =        options['state']
    self.postal_code =  options['postal_code']
    self.country =      options['country']
    self.phone_number = options['phone']
    self.email =        options['email']
  end
end
