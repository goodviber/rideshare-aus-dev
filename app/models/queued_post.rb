class QueuedPost < ActiveRecord::Base
  validates_presence_of :page_id, :post_id, :fb_id, :message
end

