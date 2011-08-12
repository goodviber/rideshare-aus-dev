class Users::SessionsController < Devise::SessionsController

  def destroy
    super
    session[:token] = nil
  end

end

