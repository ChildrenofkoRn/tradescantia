class Dashboard::UsersController < ApplicationController
  def index
    @users = User.by_date.page(params[:page])
  end
end
