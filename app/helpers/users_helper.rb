require 'digest/md5'

module UsersHelper

  def gravatar_for(user, options = { size: 50 })
    size         = options[:size] || 50
    gravatar_id  = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: h(user.fname), class: 'gravatar')
  end
  
  def toggle_family(user)
    #@user =  User.find(params[:id])
    if user.user_type.nil?
      return "1"  
    end
    
    @user_types = user.user_type.split('|')
    if (@user_types.include?("1"))
      @user_types.delete("1")
    else
      @user_types.push("1")
    end
    @user_types.join("|")
  end
  
  def toggle_friend(user)
    if user.user_type.nil?
      return "2"  
    end
    #@user =  User.find(params[:id])
    @user_types = user.user_type.split('|')
    if (@user_types.include?("2"))
      @user_types.delete("2")
    else
      @user_types.push("2")
    end
    @user_types.join("|")
  end
  
  def total_time_s(user, timespan)
    @hm = get_hours_mins(user.total_time(timespan))
    time_s = ""
    if (@hm[0] > 0)
      time_s += pluralize(@hm[0], "hour")
    end
    if (@hm[0] > 0 && @hm[1] > 0)
      time_s += ", "
    end
    if (@hm[1] > 0)
      time_s += pluralize(@hm[1], "minutes")
    end
    time_s == "" ? "0 minutes" : time_s
  end
  
  def get_hours_mins(total_hours)
    @hours = total_hours.to_i
    @minutes = ((total_hours - @hours.to_f) * 60).to_i
    @hours_mins = [@hours, @minutes]
  end
  
end
