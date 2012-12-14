class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :set_current_user

  def set_locale
puts "111 locale: #{I18n.locale}"
puts "222 params: #{params[:locale]}"
    I18n.locale = params[:locale] if !params[:locale].blank?
    #if params[:locale].blank?
    #  I18n.locale = I18n.default_locale
    #else
    #  I18n.locale = params[:locale]
    #end
  end

  def url_options(options={})
    puts "!!!!!!!!!!!!!!!!1 default_url_options is passed options: #{options.inspect}\n"
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
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

