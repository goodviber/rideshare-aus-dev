class StaffController < ApplicationController

  def show
    @posts = QueuedPost.order("post_created_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posts }
    end
  end

end

