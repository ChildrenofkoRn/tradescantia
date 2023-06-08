class Dashboard::UsersController < Dashboard::BaseController
  def index
    @users = User.by_date.page(params[:page])
  end

  def change_type
    return head :unprocessable_entity unless helpers.valid_type?(user_params[:type])

    User.where(id: user_params[:ids]).in_batches(of: 100)
        .update_all(type: user_params[:type], updated_at: Time.current)
    head :ok
  end

  private

  def user_params
    params.require(:user).permit(:type, ids: [])
  end
end
