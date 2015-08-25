# Registrar

A Ruby on Rails based web application which will provide users with the ability to register a domain name.  Once registered, the owner of the domain can invite other users to share permissions to make edits to the domains settings.

The purpose of the application is to allow to a domain name registrant to allow their web developer, or a team of web developers, to have access to update DNS records rather than sharing one account or having a third-party register the domain name.

## Features

- Register a domain name
- Share permissions with another user
- Provide a history of additions and subtractions to DNS zone file edits

## Components

- [ActiveMerchant](https://rubygems.org/gems/activemerchant) gem to connect to a payment gateway for orders placed through the app
- [Cocoon](https://rubygems.org/gems/cocoon) for nested forms, to add glue records and nameservers
- [Devise](https://rubygems.org/gems/devise) to create a user authentication system
- [CanCanCan](https://rubygems.org/gems/cancancan) used to create user permissions