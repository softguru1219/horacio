# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def new
    reset_token = params[:reset_password_token]
    unless reset_token.nil?
      username = User.find_by(reset_token: reset_token).username
      @user = User.find_by(username: username)
      password = User.get_password username
      unless password.nil?
        @user.update_attributes(password: password.strftime('%d%m%Y'))
      end
    end
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if !session[:return_to].blank?
      redirect_to session[:return_to]
      session[:return_to] = nil
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end
end
