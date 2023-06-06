class Dashboard::UsersController < Dashboard::BaseController
  def index
    @users = User.by_date.page(params[:page])
  end
end
