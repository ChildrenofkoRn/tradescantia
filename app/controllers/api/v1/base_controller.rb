class Api::V1::BaseController < ApplicationController

  before_action :doorkeeper_authorize!

  def user_not_authorized
    error = { error: "You are unauthorized for this action." }
    render json: error, status: :unauthorized
  end

  private

  def current_resource_owner
    @owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def pundit_user
    current_resource_owner
  end

  def authorize(record, query = nil)
    super([:api, record], query)
  end

end
