module DomainsHelper
  def server
    OpenSRS::Server.new(
      server:   Figaro.env.opensrs_server,
      username: Figaro.env.opensrs_username,
      password: Figaro.env.opensrs_password,
      key:      Figaro.env.opensrs_api_key,
      logger:   Rails.logger
    )
  end

  def register(domain_options = {})
    response = server.call(
      action: "SW_REGISTER",
      object: "DOMAIN",
      attributes: {
        auto_renew: '1',
        contact_set: {
          owner: {
            first_name: 'Michael',
            last_name: 'Fich',
            org_name: 'Michael Fich',
            address1: '220 King St W',
            address2: '',
            address3: '',
            city: 'Toronto',
            state: 'ON',
            postal_code: 'M5V 3M2',
            country: 'CA',
            phone: '289 937 9985',
            email: 'michael@michaelfich.com'
          },
          admin: {
            first_name: 'Michael',
            last_name: 'Fich',
            org_name: 'Michael Fich',
            address1: '220 King St W',
            address2: '',
            address3: '',
            city: 'Toronto',
            state: 'ON',
            postal_code: 'M5V 3M2',
            country: 'CA',
            phone: '289 937 9985',
            email: 'michael@michaelfich.com'
          },
          billing: {
            first_name: 'Michael',
            last_name: 'Fich',
            org_name: 'Michael Fich',
            address1: '220 King St W',
            address2: '',
            address3: '',
            city: 'Toronto',
            state: 'ON',
            postal_code: 'M5V 3M2',
            country: 'CA',
            phone: '289 937 9985',
            email: 'michael@michaelfich.com'
          },
          tech: {
            first_name: 'Michael',
            last_name: 'Fich',
            org_name: 'Michael Fich',
            address1: '220 King St W',
            address2: '',
            address3: '',
            city: 'Toronto',
            state: 'ON',
            postal_code: 'M5V 3M2',
            country: 'CA',
            phone: '289 937 9985',
            email: 'michael@michaelfich.com'
          }
        },
        custom_nameservers: '0',
        custom_tech_contact: '1',
        dns_template: '*blank*',
        domain: 'michaelfich.com',
        f_lock_domain: '1',
        f_whois_privacy: '1',
        period: '1',
        reg_username: 'example',
        reg_password: 'example123',
      }
    )
  end
end
