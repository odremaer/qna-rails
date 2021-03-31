class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    render json: current_resource_owner
  end

  def index
    @users = User.all_except(current_resource_owner)
    render json: @users
  end
end
