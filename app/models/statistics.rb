include DateUtils

class Statistics
  attr_accessor :user

  START_DATE = Date.new(2011, 12, 04)
  END_DATE   = Date.new(2012, 12, 03)

  def initialize(user)
    self.user = user
  end

  def mileage_week
    Stat.new(user, "mileage", "week")
  end

  def mileage_year
    Stat.new(user, "mileage", "year")
  end

  def time_week
    Stat.new(user, "time", "week")
  end

  def time_year
    Stat.new(user, "time", "year")
  end

  def average_mph(timespan, activity_type)
    dist_stat = timespan == "week" ? mileage_week : mileage_year
    time_stat = timespan == "week" ? time_week    : time_year
    mph = 0.0

    case activity_type
    when "run"
      mph = (dist_stat.run + dist_stat.both) / (time_stat.run + time_stat.both)
    when "walk"
      mph = dist_stat.walk / time_stat.walk
    when "overall"
      mph = dist_stat.total / time_stat.total
    end

    format("%0.2f", mph).to_f
  end

  def get_weekday_breakdown_bar_chart(timespan, opts = {})
    acts = user.activities.to_a
    wdaycount = [0, 0, 0, 0, 0, 0, 0]
    acts.each { |a| wdaycount[a.activity_date.wday] += 1 }

    c_data = GoogleVisualr::DataTable.new
    c_data.new_column('string', 'Week Day')
    c_data.new_column('number', 'Activities Logged')

    c_data.add_row(['Sun',   wdaycount[0]])
    c_data.add_row(['Mon',   wdaycount[1]])
    c_data.add_row(['Tues',  wdaycount[2]])
    c_data.add_row(['Wed',   wdaycount[3]])
    c_data.add_row(['Thurs', wdaycount[4]])
    c_data.add_row(['Fri',   wdaycount[5]])
    c_data.add_row(['Sat',   wdaycount[6]])

    c_opts = {
      width: 600, height: 240,
      legend: { position: 'none' },
      hAxis: { title: 'Day of the Week', slantedText: true, slantedTextAngle: 30 },
      vAxis: { title: 'Activities Logged' }
    }.merge(opts)

    GoogleVisualr::Interactive::ColumnChart.new(c_data, c_opts)
  end

  def get_speed_line_chart(opts = {})
    c_data = GoogleVisualr::DataTable.new
    c_data.new_column('date', 'Date')
    c_data.new_column('number', 'Run Speed')
    c_data.new_column('number', 'Walk Speed')
    c_data.new_column('number', 'Run/Walk Speed (mph)')

    user.activities.each do |act|
      speed = act.distance / (act.hours.to_f + (act.minutes.to_f / 60))
      s = format("%0.2f", speed).to_f
      case act.activity_type
      when 1 then c_data.add_row([act.activity_date, s, nil, nil])
      when 2 then c_data.add_row([act.activity_date, nil, s, nil])
      when 3 then c_data.add_row([act.activity_date, nil, nil, s])
      end
    end

    c_opts = {
      width: 600, height: 240, curveType: 'none',
      hAxis: { title: 'Activity Date' },
      vAxis: { title: 'Speed (mph)' },
      interpolateNulls: true
    }.merge(opts)

    GoogleVisualr::Interactive::LineChart.new(c_data, c_opts)
  end

  def get_pie_chart(chart_type, timespan, opts = {})
    c_title = chart_type == "mileage" ? "Mileage Logged" : "Time Logged"
    c_title += timespan == "week" ? " (week)" : " (year)"

    stat_data = case [chart_type, timespan]
                when ["mileage", "week"] then mileage_week
                when ["mileage", "year"] then mileage_year
                when ["time",    "week"] then time_week
                else                          time_year
                end

    c_data = GoogleVisualr::DataTable.new
    c_data.new_column('string', 'Activity Type')
    c_data.new_column('number', c_title)
    c_data.add_rows(3)
    c_data.set_cell(0, 0, 'Miles Run');       c_data.set_cell(0, 1, stat_data.run)
    c_data.set_cell(1, 0, 'Miles Walked');    c_data.set_cell(1, 1, stat_data.walk)
    c_data.set_cell(2, 0, 'Miles Run/Walked'); c_data.set_cell(2, 1, stat_data.both)

    c_opts = { width: 600, height: 240, is3D: true }.merge(opts)

    GoogleVisualr::Interactive::PieChart.new(c_data, c_opts)
  end

  def get_weeks
    weeks
  end

  def self.ideal_progress(timespan)
    case timespan
    when "week"
      format("%0.2f", ((Date.today.wday + 1).to_f * 10) / 7).to_f
    when "year"
      format("%0.2f", ((Date.today - START_DATE).to_f * 500) / 365).to_f
    end
  end
end

class Stat
  attr_accessor :run, :walk, :both, :total

  def initialize(user, stat_type, timespan)
    startdate   = year[:start]
    self.total  = 0.0

    startdate = current_week if timespan == "week"

    if stat_type == "mileage"
      self.total = user.total_miles(timespan)
    elsif stat_type == "time"
      self.total = user.total_time(timespan)
    end

    case stat_type
    when "mileage"
      self.run  = user.activities.where("activity_type = 1 AND activity_date >= ?", startdate).sum(:distance)
      self.walk = user.activities.where("activity_type = 2 AND activity_date >= ?", startdate).sum(:distance)
      self.both = to_2f([total - run - walk, 0.0].max)
    when "time"
      self.run  = user.activities.where("activity_type = 1 AND activity_date >= ?", startdate).sum(:hours).to_f +
                  user.activities.where("activity_type = 1 AND activity_date >= ?", startdate).sum(:minutes).to_f / 60
      self.walk = user.activities.where("activity_type = 2 AND activity_date >= ?", startdate).sum(:hours).to_f +
                  user.activities.where("activity_type = 2 AND activity_date >= ?", startdate).sum(:minutes).to_f / 60
      self.both = to_2f([total - run - walk, 0.0].max)
    end
  end

  private

    def to_2f(n)
      format("%0.2f", n).to_f
    end
end
