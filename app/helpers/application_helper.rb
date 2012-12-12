module ApplicationHelper

  def page_title
    if @content_for_title
      'Pavesiu' + (" | " + @content_for_title).to_s
    else
      'Pavesiu | visas keliones vienoje vietoje'
    end
  end

  def page_description
    @content_for_description
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
    
    else
      link_to image_tag('fb-login-button.png'), "/users/sign_in/?locale=" + (I18n.locale.to_s)
    end
    
  end
  
  #Returns the hosted button ID for the donate button
  def paypal_hosted_button_id
  
     if (I18n.locale == :en)
     	#use Rideshare Australia button
  	return "LGC3NXBCVLMVL" 
     elsif (I18n.locale == :lt)
     	#Pavesiu.Lt button
  	return "C9BAH2FSK9E7J" 
     else	
     	return I18n.locale; 
     end
  end

end
