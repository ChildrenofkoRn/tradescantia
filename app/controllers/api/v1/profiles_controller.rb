class Api::V1::ProfilesController < Api::V1::BaseController

  before_action :authorize_profile!
  after_action :verify_authorized

  def me
    serialize(current_resource_owner, params: { email: true })
  end

  def index
    users = policy_scope(User, policy_scope_class: Api::V1::ProfilePolicy::Scope)
                              .page(params[:page]).includes(:reviews, :ranks)
    serialize(users, params: { owner: current_resource_owner } )
  end

  private

  def authorize_profile!
    authorize(:profile)
  end

  def serialize(...)
    render json: ProfileSerializer.new(...).serializable_hash.to_json
  end

end
