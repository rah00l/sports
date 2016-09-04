class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  # this method invokes only when following configuration enable from active_admin.rb
  # config.authentication_method = :authenticate_admin_user!
  def authenticate_admin_user!
    authenticate_user!
    unless current_user.admin?
      flash['alert'] = 'This area is restricted to administrators only.'
      redirect_to root_path
    end
  end

  def current_admin_user
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end
end
