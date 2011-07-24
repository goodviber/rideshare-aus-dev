module ApplicationHelper

  def page_title
    if @content_for_title
      'Cocoride' + (" - " + @content_for_title).to_s
    else
      'Cocoride - Social ridesharing'
    end
  end

end

