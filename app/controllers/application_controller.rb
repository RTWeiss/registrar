class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def server
    OpenSRS::Server.new(
      server:   Figaro.env.opensrs_server,
      username: Figaro.env.opensrs_username,
      password: Figaro.env.opensrs_password,
      key:      Figaro.env.opensrs_api_key,
      logger:   Rails.logger
    )
  end
end
