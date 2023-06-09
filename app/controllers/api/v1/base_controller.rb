class Api::V1::BaseController < ApplicationController

  before_action :doorkeeper_authorize!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def doorkeeper_unauthorized_render_options(error: nil)
    message = error.nil? ? "Not authorized" : error
    { json: { errors: message } }
  end

  def user_not_authorized
    error = { errors: "You are unauthorized for this action." }
    render json: error, status: :unauthorized
  end

  private

  def current_resource_owner
    @owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def pundit_user
    current_resource_owner
  end

  def authorize(record, ...)
    super([:api, :v1, record], ...)
  end

end
