class Dashboard::UsersController < Dashboard::BaseController
  def index
    @users = User.by_date.page(params[:page])
  end

  def make_admin
    User.where(id: user_params[:ids]).update_all(type: "Admin", updated_at: Time.current)
    head :ok
  end

  private

  def user_params
    params.require(:user).permit(ids: [])
  end
end
