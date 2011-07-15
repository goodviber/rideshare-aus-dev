class LoginController < ApplicationController

  def user_login

    session[:is_new_user] = !User.where(:fb_id => params[:fb_id]).exists?
    user = User.find_or_create_by_fb_id(params[:fb_id])

    user.first_name = params[:first_name]
    user.last_name = params[:last_name]
    user.last_login = Time.now
    user.is_admin = false unless User.where(:fb_id => params[:fb_id]).exists?

    user.save

    session[:user_id] = user.id

    respond_to do |format|
      format.html { render :json => user.id} #, :status => 200 }
    end
  end

end

