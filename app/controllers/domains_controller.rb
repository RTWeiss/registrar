class DomainsController < ApplicationController
  before_action :set_domain, only: [:show, :edit, :update, :destroy]

  def index
    @domains = Domain.all
  end

  def show
  end

  def new
    @domain = Domain.new

    registration = {
      organization:   Faker::Company.name,
      first_name:     Faker::Name.first_name,
      last_name:      Faker::Name.last_name,
      address1:       Faker::Address.street_address,
      address2:       Faker::Address.secondary_address,
      city:           Faker::Address.city,
      state:          Faker::Address.state_abbr,
      country:        "US",
      postal_code:    Faker::Address.postcode,
      email:          Faker::Internet.email,
      phone_number:   Faker::PhoneNumber.phone_number
    }

    @domain.name      = Faker::Internet.domain_word + ".com"
    @domain.owner     = Owner.new registration
    @domain.admin     = Admin.new registration
    @domain.billing   = Billing.new registration
    @domain.tech      = Tech.new registration


  end

  def edit
  end

  def create
    @domain         = Domain.new domain_params

    @domain.owner   = Owner.new contact_params "owner"
    @domain.admin   = Admin.new contact_params "admin"
    @domain.billing = Billing.new contact_params "billing"
    @domain.tech    = Tech.new contact_params "tech"

    if @domain.valid?
      registration = register(@domain)
      response = registration.response['response_text']
      if registration.success?
        binding.pry
        @domain.save
        redirect_to domain_url(@domain), notice: response
      else
        binding.pry
        render :new, alert: response
      end
    else
      render :new
    end

  end

  def update
    if @domain.update(domain_params)
      redirect_to @domain, notice: 'Domain was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @domain.destroy
    redirect_to domains_url, notice: 'Domain was successfully destroyed.'
  end

  private
    def set_domain
      @domain = Domain.find_by(name: params[:name])
    end

    def domain_params
      params.require(:domain).permit(:name, :lock, :privacy, :epp)
    end

    def contact_params(type)
      params
        .require(type.underscore.to_sym)
        .permit(:organization, :first_name, :last_name, :address1, :address2, :address3,
          :city, :state, :country, :postal_code, :email, :phone_number, :type)
    end

    def register(domain)
      response = server.call(
        action:                 'SW_REGISTER',
        object:                 'DOMAIN',
        attributes: {
          auto_renew:           '1',
          contact_set: {
            owner:              domain.owner.as_json,
            admin:              domain.admin.as_json,
            billing:            domain.billing.as_json,
            tech:               domain.tech.as_json
          },
          custom_nameservers:   '0',
          custom_tech_contact:  '1',
          dns_template:         '*blank*',
          domain:               domain.name,
          f_lock_domain:        domain.lock ? '1' : '0',
          f_whois_privacy:      domain.privacy ? '1' : '0',
          period:               '1',
          reg_username:         'example',
          reg_password:         'example123',
        }
      )
    end
end
