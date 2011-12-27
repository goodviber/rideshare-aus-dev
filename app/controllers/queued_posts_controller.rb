class QueuedPostsController < ApplicationController

  before_filter :authenticate_user!

  def index
    respond_to do |format|
      format.html { redirect_to posts_need_attention_url }
    end
  end

  def destroy
    @queued_post = QueuedPost.find(params[:id])
    #@queued_post.destroy
    @queued_post.deleted_at = DateTime.now
    @queued_post.process_type = 'D'
    @queued_post.deleted_msg = "Removed by " + current_user.full_name.to_s
    @queued_post.save

    #delete related trip, if exists
    if @queued_post.trip_id
      trip = Trip.find(@queued_post.trip_id).delete
    end

    respond_to do |format|
      format.html { redirect_to posts_need_attention_url, :notice => 'Post was successfully removed.' }
      format.json { head :ok }
    end
  end

  def undestroy
    @queued_post = QueuedPost.find(params[:id])
    #@queued_post.destroy
    @queued_post.deleted_at = nil
    @queued_post.process_type = nil
    @queued_post.save

    respond_to do |format|
      format.html { redirect_to posts_deleted_url, :notice => 'Post was successfully un-deleted.' }
      format.json { head :ok }
    end
  end

  def need_attention
    @selected_tab = "need_att"
    @posts = QueuedPost.where("process_type is null").order("post_created_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posts }
    end
  end

  def manually_processed
    @selected_tab = "man_processed"
    @posts = QueuedPost.where(:process_type => "M").order("processed_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posts }
    end
  end

  def auto_processed
    @selected_tab = "auto_processed"
    @posts = QueuedPost.where(:process_type => "A").order("post_created_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posts }
    end
  end

  def deleted
    @selected_tab = "deleted"
    @posts = QueuedPost.where(:process_type => "D").order("deleted_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posts }
    end
  end

end

