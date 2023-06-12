# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    username = resource_params['username']
    @user = User.find_by(username: username)
    email = @user.email unless @user.nil?

    if email.nil?
      flash[:password_reset_fail] = t('devise.failure.reset_password')
      respond_with({}, location: resetting_password_path_for(resource_name))
    else
      params['user']['email'] = email
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        reset_password_token = resource.reset_password_token
        @user.update_attributes(reset_token: reset_password_token)

        flash[:password_reset_alert] = t('devise.passwords.send_instructions')
        respond_with({}, location: resetting_password_path_for(resource_name))
      else
        flash[:password_reset_fail] = t('devise.failure.reset_password')
        respond_with({}, location: resetting_password_path_for(resource_name))
      end
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   stored_location_for(resource) || new_user_session_path
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   flash[:password_reset_success] = t('devise.passwords.created')
  #   new_session_path(resource_name) if is_navigational_format?
  # end

  def resetting_password_path_for(resource)
    stored_location_for(resource) || new_user_password_path
  end
end
