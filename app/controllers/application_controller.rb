class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :set_current_user

  def set_locale
    I18n.locale = params[:locale] if !params[:locale].blank?
    #if params[:locale].blank?
    #  I18n.locale = I18n.default_locale
    #else
    #  I18n.locale = params[:locale]
    #end
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  def login_required
    if user_signed_in?
      return true
    else
      redirect_to new_user_session_url
    end
  end

  #def current_user
  #  @current_user ||= User.find(session[:user_id]) if session[:user_id]
  #end
  #helper_method :current_user

  include Devise::Controllers::Helpers
  helper_method :current_user
  
  def set_current_user
    User.current_user = current_user
  end
end

