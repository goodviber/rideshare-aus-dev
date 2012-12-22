class QueuedPost < ActiveRecord::Base
  validates_presence_of :page_id, :post_id, :fb_id, :message

  def fb_page(page_id)
    if page_id == "176073525768645"
      "tranzuok"
    elsif page_id == "286064822992"
      "vaziuoju"
    elsif page_id == "161847627166445"
      "pavesiu"
    end
  end
end

