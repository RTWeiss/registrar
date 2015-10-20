# Registrar

A Ruby on Rails based web application which will provide users with the ability to register a domain name.  Once registered, the owner of the domain can invite other users to share permissions to make edits to the domains settings.

The purpose of the application is to allow to a domain name registrant to allow their web developer, or a team of web developers, to have access to update DNS records rather than sharing one account or having a third-party register the domain name.

## Features

- Register a domain name
- Share permissions with another user
- Provide a history of additions and subtractions to DNS zone file edits

## Components

- [ActiveMerchant](https://rubygems.org/gems/activemerchant) gem to connect to a payment gateway for orders placed through the app
- [OpenSRS](https://rubygems.org/gems/opensrs) to abstract the OpenSRS XML API into Ruby code.
- [Devise](https://rubygems.org/gems/devise) to create a user authentication system
- [CanCanCan](https://rubygems.org/gems/cancancan) used to create user permissions
- [Bourbon](https://rubygems.org/gems/bourbon) is a set of SCSS mixins to assist in CSS layouts.
- [Neat](https://rubygems.org/gems/bourbon) a lightweight grid system built on the Bourbon framework.