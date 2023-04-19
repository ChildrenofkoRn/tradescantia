class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    authorize(:profile)
    render json: current_resource_owner
  end

end
