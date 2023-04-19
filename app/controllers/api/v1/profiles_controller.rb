class Api::V1::ProfilesController < Api::V1::BaseController

  before_action :authorize_profile!
  after_action :verify_authorized

  def me
    render json: ProfileSerializer.new(current_resource_owner).serializable_hash.to_json
  end

  private

  def authorize_profile!
    authorize(:profile)
  end

end
