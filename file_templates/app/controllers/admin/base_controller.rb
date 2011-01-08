module Admin
  class BaseController < ApplicationController
    before_filter :authenticate_user!
    before_filter :require_admin

    private

    def require_admin
      unless current_user.admin?
        flash[:alert] = t(:not_authorized)
        redirect_to root_url
      end
    end
  end
end
