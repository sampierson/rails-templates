module Admin
  class SettingsController < BaseController
    def edit
      @settings = AppConfiguration.instance
    end

    def update
      @settings = AppConfiguration.instance
      if @settings.update_attributes params[:app_configuration]
        flash[:notice] = t('settings_saved')
        redirect_to edit_admin_settings_path
      else
        flash[:alert] = @settings.errors.full_messages
        render :edit
      end
    end
  end
end
