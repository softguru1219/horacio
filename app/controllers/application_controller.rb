# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :switch_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_user
    warden.user
  end

  def warden
    request.env['warden']
  end

  def switch_locale
    I18n.locale = :fr
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || schedule_path
  end

  def validate_signin
    unless current_user
      redirect_to new_user_session_path, alert: t('devise.failure.inactive')
    end
  end
end
