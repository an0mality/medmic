class Monitoring < ApplicationRecord

  belongs_to :user
  # belongs_to :organization

  def self.count_user_visits(period, date)
    labels = []
    values = []

    monitoring = Monitoring
    case period
      when 'now'
        monitoring_day = monitoring.where('date >=? and date <= ?', DateTime.now.at_beginning_of_day+3.hour+date.day, DateTime.now.at_end_of_day+3.hour+date.day).group("DATE_PART('hour', date)").count.sort.to_h
        labels = monitoring_day.keys.map{|k| (k+3).to_i.to_s+":00"}
        values = monitoring_day.values
      when 'week'
        monitoring_week = monitoring.where('date >=? and date <= ?', DateTime.now.at_beginning_of_week+3.hour+date.week, DateTime.now.at_end_of_week+3.hour+date.week).group("DATE_PART('day', date)").group("DATE_PART('month', date)").count.sort.to_h
        labels = monitoring_week.keys.map{|k| k.map{|q| q.to_i}}.map{|k| k.join('/')}
        values = monitoring_week.values
      when 'month'
        monitoring_month = monitoring.where('date >=? and date <= ?', DateTime.now.at_beginning_of_month+3.hour+date.month, DateTime.now.at_end_of_month+3.hour+date.month).group("DATE_PART('day', date)").group("DATE_PART('month', date)").count.sort.to_h
        labels = monitoring_month.keys.map{|k| k.map{|q| q.to_i}}.map{|k| k.join('/')}
        values = monitoring_month.values
    end
    return labels,values

  end

  def self.count_path_visits(period, date)
    labels_cpv = []
    values_cpv = []

    monitoring = Monitoring
    case period
      when 'now'
        monitoring_day = monitoring.where('date >=? and date <= ?', DateTime.now.at_beginning_of_day+3.hour+date.day, DateTime.now.at_end_of_day+3.hour+date.day).group(:path).count.to_h.sort{|a,b| a[1]<=>b[1]}.reverse.to_h
        labels_cpv = monitoring_day.keys
        values_cpv = monitoring_day.values
      when 'week'
        monitoring_week = monitoring.where('date >=? and date <= ?', DateTime.now.at_beginning_of_week+3.hour+date.week, DateTime.now.at_end_of_week+3.hour+date.week).group(:path).count.to_h.sort{|a,b| a[1]<=>b[1]}.reverse.to_h
        labels_cpv = monitoring_week.keys
        values_cpv = monitoring_week.values
      when 'month'
        monitoring_month = monitoring.where('date >=? and date <= ?', DateTime.now.at_beginning_of_month+3.hour+date.month, DateTime.now.at_end_of_month+3.hour+date.month).group(:path).count.to_h.sort{|a,b| a[1]<=>b[1]}.reverse.to_h
        labels_cpv = monitoring_month.keys
        values_cpv = monitoring_month.values
    end
    return labels_cpv,values_cpv

  end

  def self.user_visits(period, date)
    labels_uv = []
    values_uv = []
    monitoring = User.joins(:monitorings, :organization)
    case period
      when 'now'
        monitoring_day = monitoring.where('date >=? and date <= ? and user_id != ?', DateTime.now.at_beginning_of_day+3.hour+date.day, DateTime.now.at_end_of_day+3.hour+date.day,0).group('organizations.name').distinct.count.to_h.sort{|a,b| a[1]<=>b[1]}.reverse.to_h
        # sort_hash = monitoring_day.sort{|a,b| a[1]<=>b[1]}.to_h
        labels_uv = monitoring_day.keys
        values_uv = monitoring_day.values

      when 'week'
        monitoring_week = monitoring.where('date >=? and date <= ? and user_id != ?', DateTime.now.at_beginning_of_week+3.hour+date.week, DateTime.now.at_end_of_week+3.hour+date.week,0).group('organizations.name').distinct.count.to_h.sort{|a,b| a[1]<=>b[1]}.reverse.to_h

        labels_uv = monitoring_week.keys
        values_uv = monitoring_week.values

      when 'month'
        monitoring_month = monitoring.where('date >=? and date <= ? and user_id != ?', DateTime.now.at_beginning_of_month+3.hour+date.month, DateTime.now.at_end_of_month+3.hour+date.month,0).group('organizations.name').distinct.count.to_h.sort{|a,b| a[1]<=>b[1]}.reverse.to_h

        labels_uv = monitoring_month.keys
        values_uv = monitoring_month.values
    end

    return labels_uv, values_uv
  end



  def self.count_org(period, date)
    h = {}
    user = User.joins(:monitorings, :organization)

    case period
      when 'now'
        monitoring_day = user.where('date >=? and date <= ? and user_id != ?', DateTime.now.at_beginning_of_day+3.hour+date.day, DateTime.now.at_end_of_day+3.hour+date.day,0).group('organizations.name').group('users.id').count.to_h.sort{|a,b| a[1]<=>b[1]}.reverse.to_h
        monitoring_day.keys.map{|k| h[k[0]]=[]}
        monitoring_day.keys.map{|k| h[k[0]]=h[k[0]].sort.push([k[1], monitoring_day[k]])}
        h.values.map{|v|v.map{|k|k[0]=User.find(k[0]).user_status}}
        data = h
      when 'week'
        monitoring_week = user.where('date >=? and date <= ? and user_id != ?', DateTime.now.at_beginning_of_week+3.hour+date.week, DateTime.now.at_end_of_week+3.hour+date.week,0).group('organizations.name').group('users.id').count.to_h.sort{|a,b| a[1]<=>b[1]}.reverse.to_h
        monitoring_week.keys.map{|k| h[k[0]]=[]}
        monitoring_week.keys.map{|k| h[k[0]]=h[k[0]].push([k[1], monitoring_week[k]])}
        h.values.map{|v|v.map{|k|k[0]=User.find(k[0]).user_status}}
        data = h
      when 'month'
        monitoring_month = user.where('date >=? and date <= ? and user_id != ?', DateTime.now.at_beginning_of_month+3.hour+date.month, DateTime.now.at_end_of_month+3.hour+date.month,0).group('organizations.name').group('users.id').count.to_h.sort{|a,b| a[1]<=>b[1]}.reverse.to_h
        monitoring_month.keys.map{|k| h[k[0]]=[]}
        monitoring_month.keys.map{|k| h[k[0]]=h[k[0]].push([k[1], monitoring_month[k]])}
        h.values.map{|v|v.map{|k|k[0]=User.find(k[0]).user_status}}
        data = h
    end

    return data
  end






end
