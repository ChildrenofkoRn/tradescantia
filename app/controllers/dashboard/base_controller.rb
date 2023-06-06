class Dashboard::BaseController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_dashboard!
  after_action :verify_authorized

  private

  def authorize_dashboard!
    authorize(:dashboard)
  end
end
