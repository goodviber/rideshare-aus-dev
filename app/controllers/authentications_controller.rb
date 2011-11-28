class AuthenticationsController < ApplicationController

  def index
    @authentications = current_user.authentications if current_user
  end

  def create

    #debug output
    #render :text => request.env["omniauth.auth"].to_yaml

    omniauth = request.env["omniauth.auth"]
    session['token'] = omniauth['credentials']['token']

    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

    if authentication   #user exists, sign in

      #user was system generated, update their email since we now have email access permission
      if User.find(authentication.user_id).email.include? "@system.com"
        u = User.find(authentication.user_id)
        u.email = omniauth['user_info']['email'] if omniauth['user_info']['email']
        u.save
      end

      flash[:notice] = "You are now logged in."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user  #add authentication to user that is logged in
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      redirect_to authentications_url, notice: 'Authentication successfull.'
    else                #user signing in directly with 3rd party provider (ie facebook)
      email = omniauth['user_info']['email']
      existing_user = User.find_by_email(email) if email

      if !existing_user
        user = User.new
        user.first_name = omniauth['user_info']['first_name']   if omniauth['user_info']['first_name']
        user.last_name = omniauth['user_info']['last_name']     if omniauth['user_info']['last_name']
        user.email = omniauth['user_info']['email']             if omniauth['user_info']['email']
        user.password = "123456"  #!! DEV ONLY !!

        user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
        user.save!

        flash[:notice] = "You are now logged in."
        sign_in_and_redirect(:user, user)
      else
        existing_user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
        existing_user.save!

        flash[:notice] = "You are now logged in. Account has been linked to existing account #{email}"
        sign_in_and_redirect(:user, existing_user)
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to authentications_url, notice: 'Authentication destroyed!'
  end

  def facebook_logout
    if session[:token]
      split_token = session[:token].split("|")
      fb_api_key = split_token[0]
      fb_session_key = split_token[1]
      redirect_to "http://www.facebook.com/logout.php?api_key=#{fb_api_key}&session_key=#{fb_session_key}&confirm=1&next=#{destroy_user_session_url}";
    end
  end

end

