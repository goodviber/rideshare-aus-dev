class QueuedPostsController < ApplicationController

  def index
    respond_to do |format|
      format.html { redirect_to posts_need_attention_url }
    end
  end

  def destroy
    @queued_post = QueuedPost.find(params[:id])
    @queued_post.destroy

    respond_to do |format|
      format.html { redirect_to posts_need_attention_url, :notice => 'Post was successfully removed.' }
      format.json { head :ok }
    end
  end

  def need_attention
    @posts = QueuedPost.order("post_created_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posts }
    end
  end

end

