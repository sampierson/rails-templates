class Devise::SessionsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  include Devise::Controllers::InternalHelpers

  # GET /resource/sign_in
  def new
    clean_up_passwords(build_resource)
    render_with_scope :new
  end

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "new")
    if AppConfiguration.site_availability <= SiteAvailability::PREVENT_USER_LOGINS && resource.role != 'admin'
      flash[:alert] = t('site_availability.maintenance')
      sign_out_and_redirect(resource_name)
    else
      set_flash_message :notice, :signed_in
      sign_in_and_redirect(resource_name, resource)
    end
  end

  # GET /resource/sign_out
  def destroy
    set_flash_message :notice, :signed_out if signed_in?(resource_name)
    sign_out_and_redirect(resource_name)
  end
end
