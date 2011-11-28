module ApplicationHelper

  def page_title
    if @content_for_title
      'Pavesiu.lt' + (" | " + @content_for_title).to_s
    else
      'Pavesiu.lt | visas keliones vienoje vietoje'
    end
  end

  def fb_image_url

    if current_user

      fb_id = current_user.authentications.where(:provider => "facebook").first.uid if current_user.authentications.count > 0
      if fb_id
        src = "https://graph.facebook.com/" + fb_id + "/picture"
        image_tag(src, :alt => "Profile Image")
      else
        image_tag("default_profile_image.png", :alt => "Profile Image")
      end
    end
  end

end

