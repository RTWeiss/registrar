class DomainsController < ApplicationController
  before_action :set_domain, only: [:show, :edit, :update, :destroy]

  def index
    @domains = Domain.all
  end

  def show
  end

  def new
    @domain = Domain.new

    whois_record = {
      organization: Faker::Company.name,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      address1: Faker::Address.street_address,
      address2: Faker::Address.secondary_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      country: "US",
      postal_code: Faker::Address.postcode,
      email: Faker::Internet.email,
      phone_number: Faker::PhoneNumber.phone_number
    }

    @domain.name = Faker::Internet.domain_word + ".com"
    @domain.owner = Owner.new(whois_record)
    @domain.administrator = Administrator.new(whois_record)
    @domain.technical = Technical.new(whois_record)
    @domain.billing = Billing.new(whois_record)
  end

  def edit
  end

  def create
    @domain = Domain.new(domain_params)

    @domain.owner         = Owner.new contact_params("owner")
    @domain.administrator = Administrator.new contact_params("administrator")
    @domain.billing       = Billing.new contact_params("billing")
    @domain.technical     = Technical.new contact_params("technical")

    render json: @domain.to_json(include: [:owner, :administrator, :billing, :technical])

    # respond_to do |format|
    #   if @domain.save
    #     format.html { redirect_to @domain, notice: 'Domain was successfully created.' }
    #     format.json { render :show, status: :created, location: @domain }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @domain.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /domains/1
  # PATCH/PUT /domains/1.json
  def update
    respond_to do |format|
      if @domain.update(domain_params)
        format.html { redirect_to @domain, notice: 'Domain was successfully updated.' }
        format.json { render :show, status: :ok, location: @domain }
      else
        format.html { render :edit }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @domain.destroy
    respond_to do |format|
      format.html { redirect_to domains_url, notice: 'Domain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_domain
      @domain = Domain.find_by(name: params[:name])
    end

    def domain_params
      params.require(:domain).permit(:name, :lock, :privacy, :epp)
    end

    def contact_params(type)
      params.require(type.underscore.to_sym).permit(
        :organization, :first_name, :last_name, :address1, :address2, :address3,
        :city, :state, :country, :postal_code, :email, :phone_number, :type
      )
    end
end
