class DomainsController < ApplicationController
  before_action :set_domain, only: [:show, :edit, :update, :destroy]

  def index
    get_all_domains.each { |d| Domain.find_or_create_by(name: d['name']) }
    @domains = Domain.all
  end

  def show
    api_query_results = get_domain(params[:name])
    if api_query_results.success?
      @domain.epp = get_epp_code(@domain) if @domain.epp.nil? || @domain.epp.empty?
      response = api_query_results.response['attributes']

      @domain.autorenew = response['let_expire']
      @domain.privacy = get_privacy_status(@domain)
      @domain.lock = get_lock_status(@domain)

      nameservers = response['nameserver_list']
      nameservers.each do |ns|
        Nameserver.find_or_create_by(order: ns['sortorder'], domain: @domain) do |nameserver|
          nameserver.name = ns['name']
        end
      end
      @domain.nameservers.where.not(order: [1..nameservers.count]).destroy_all

      @domain.registration = DateTime.parse(response['registry_createdate'])
      @domain.expiry = DateTime.parse(response['registry_expiredate'])

      contacts = response['contact_set']
      @domain.owner.from_json(contacts['owner'])
      @domain.admin.from_json(contacts['admin'])
      @domain.billing.from_json(contacts['billing'])
      @domain.tech.from_json(contacts['tech'])

      @domain.save
      render :show
    else
      @domain_name = params[:name]
      if domain_available?(@domain_name)
        redirect_to new_domain_path(name: @domain_name)
      else
        render :unavailable
      end
    end
  end

  def new
    @domain = Domain.new

    if params[:name]
      @domain.name = params[:name]
    else
      @domain.name = Faker::Internet.domain_word + ".com"
    end

    render :unavailable unless domain_available?(@domain.name)

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
      phone_number:   Faker::Base.numerify("+1.9864434825")
    }

    @domain.owner     = Owner.new registration
    @domain.admin     = Admin.new registration
    @domain.billing   = Billing.new registration
    @domain.tech      = Tech.new registration
  end

  def edit
  end

  def create
    @domain = Domain.new(domain_params)

    @domain.owner   = Owner.new contact_params "owner"
    @domain.admin   = Admin.new contact_params "admin"
    @domain.billing = Billing.new contact_params "billing"
    @domain.tech    = Tech.new contact_params "tech"

    if @domain.valid?
      registration = register(@domain)
      response = registration.response['response_text']
      if registration.success?
        @domain.epp = get_epp_code @domain
        @domain.save
        redirect_to domain_url(@domain), notice: response
      else
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

  def unavailable
    @domain_name = params[:name]
  end

  private
    def set_domain
      @domain = Domain.find_by(name: params[:name])
    end

    def domain_params
      params.require(:domain).permit(:name, :lock, :privacy, :epp)
    end

    def get_domain(name)
      server.call(
        action: 'get',
        object: 'domain',
        attributes: {
          domain: name,
          type: 'all_info'
        }
      )
    end

    def contact_params(type)
      params
        .require(type.underscore.to_sym)
        .permit(:organization, :first_name, :last_name, :address1, :address2, :address3,
          :city, :state, :country, :postal_code, :email, :phone_number, :type)
    end

    def register(domain)
      response = server.call(
        action:                 'sw_register',
        object:                 'domain',
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

    def get_epp_code(domain)
      query = server.call(
        action: 'get',
        object: 'domain',
        attributes: { domain: domain.name, type: 'domain_auth_info' }
      )
      query.response['attributes']['domain_auth_info']
    end

    def get_privacy_status(domain)
      query = server.call(
        action: 'get',
        object: 'domain',
        attributes: { domain: domain.name, type: 'whois_privacy_state' }
      )
      query.response['attributes']['state'] === "enabled"
    end

    def get_lock_status(domain)
      query = server.call(
        action: 'get',
        object: 'domain',
        attributes: { domain: domain.name, type: 'status' }
      )
      query.response['attributes']['lock_state'] === "1"
    end

    def get_all_domains
      min_expiry = Date.today
      max_expiry = min_expiry + 10.years
      query = server.call(
        action: 'get_domains_by_expiredate',
        object: 'domain',
        attributes: {
          exp_to: max_expiry.strftime("%Y-%m-%d"),
          exp_from: min_expiry.strftime("%Y-%m-%d"),
          state: 'active'
        }
      )
      query.response['attributes']['exp_domains']
    end

    def domain_available?(name)
      query = server.call(
        action: 'lookup',
        object: 'domain',
        attributes: {
          domain: name
        }
      )
      query.response['response_code'] == "210"
    end
end
