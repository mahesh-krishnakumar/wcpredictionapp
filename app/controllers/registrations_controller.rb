class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def new
    @group = Group.find_by(code: params[:code]) or raise_not_found
    super
  end

  def create
    @group = Group.find_by(code: params[:user][:group_code])
    params[:code] = params[:user][:group_code] # Weird patch to retain group code in params
    super
    current_user.groups << @group if current_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :name, :nick_name, :team_id, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :nick_name, :team_id])
  end

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    return super if params['password']&.present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except('current_password'))
  end

  def raise_not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end