class PagesController < ApplicationController
  before_filter :authenticate, :only => [:leaderboards]
  def home
    @title = "Home"
    if signed_in?      
      @activity = Activity.new if signed_in?
      @feed_items = current_user.feed.paginate(:page => params[:page], :per_page => 5)
      @weekly_leader_items = convert_leader_items(User.leaders("week"), "week", false, 5)
      @yearly_leader_items = convert_leader_items(User.leaders("year"), "year", false, 5)
    end
	
	respond_to do |format|
	  format.html
	  format.js
	end
  end

  def leaderboards
    @title = "Leaderboards"
    @weekly_leader_items = convert_leader_items(User.leaders("week"), "week", true)
    @yearly_leader_items = convert_leader_items(User.leaders("year"), "year", true)
  end

  def contact
    @title = "Contact Info"
  end
  
  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end
  
  private
  
    def convert_leader_items(users, timespan, show_zeros = false, max_items = users.length )
      leader_items = []
      for i in 0...[max_items, users.length].min
	    stats = nil
		if (timespan == "week")
		  stats = Statistics.new(users[i]).mileage_week
		else
		  stats = Statistics.new(users[i]).mileage_year
		end
        hm = get_hours_mins(users[i].total_time(timespan))
        total_miles = stats.run + stats.walk + stats.both #users[i].total_miles(timespan)
        if (show_zeros || (!show_zeros && total_miles > 0))
          if (current_user.can_view_user?(users[i]))
            leader_items.push({:name => "#{users[i].fname} #{users[i].lname}",
								 :drun => "%0.2f" % (stats.run + stats.both),
								 :dwalk => "%0.2f" % stats.walk,
                                 :distance => "%0.2f" % total_miles,
                                 :time => "%02d:%02d" % [hm[0], hm[1]] })
          end
        end                      
      end
      return leader_items
    end
    
    def get_hours_mins(total_hours)
      @hours = total_hours.to_i
      @minutes = ((total_hours - @hours.to_f) * 60).to_i
      @hours_mins = [@hours, @minutes]
    end

end
