module QueuedPostsHelper

  def need_att_count
    @count = QueuedPost.where("process_type is null").order("post_created_at DESC").count
  end

  def man_processed_count
    @count = QueuedPost.where(:process_type => "M").order("post_created_at DESC").count
  end

  def auto_processed_count
    @count = QueuedPost.where(:process_type => "A").order("post_created_at DESC").count
  end

end

