class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :default_expires_in

  def default_expires_in
    expires_in 24.hours, :public => true
  end
end
