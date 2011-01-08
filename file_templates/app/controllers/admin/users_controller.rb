module Admin
  class UsersController < BaseController
    load_and_authorize_resource
    helper_method :sort_column, :sort_direction

    def index
      @users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
    end

    private

    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "email"
    end

    def sort_direction
      %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"
    end
  end
end
