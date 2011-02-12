class PreferencesController < ApplicationController
  before_filter :authenticate_user!

  def edit
  end

  def update
    head :ok
  end

  def change_password
    old_pass     = params[:old_password]
    user         = params[:user] || {}
    new_pass     = user[:password]
    confirmation = user[:password_confirmation]

    if old_pass.blank? || new_pass.blank? || confirmation.blank?
      redirect_to edit_preferences_path, :alert => t('preferences.must_supply_old_and_new_passwords')
      return
    end

    if current_user.valid_password?(old_pass)
      if current_user.update_attributes(:password => new_pass, :password_confirmation => confirmation)
        redirect_to edit_preferences_path, :notice => t('preferences.password_updated')
      else
        flash[:alert] = t('preferences.password_update_problem')
        render :action => :edit
      end
    else
      redirect_to edit_preferences_path, :alert => t('preferences.bad_old_password')
    end
  end
end
