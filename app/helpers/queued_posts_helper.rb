module QueuedPostsHelper

  def need_att_count
    @count = QueuedPost.where("process_type is null").count
  end

  def man_processed_count
    @count = QueuedPost.where(:process_type => "M").count
  end

  def auto_processed_count
    @count = QueuedPost.where(:process_type => "A").count
  end

  def deleted_count
    @count = QueuedPost.where(:process_type => "D").count
  end

end

