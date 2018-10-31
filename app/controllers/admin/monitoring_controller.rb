class Admin::MonitoringController < Admin::ApplicationController

  before_action :check_admin

  def index

  end


  def get_data_chart

    date = params[:count].to_i

    if params[:now] == "true"
      time_now = (DateTime.now+date.days).strftime("%d/%m/%Y")
      x_cuv_now, y_cuv_now = Monitoring.count_user_visits('now', date)
      x_cpv_now, y_cpv_now = Monitoring.count_path_visits('now', date)
      x_uv_now, y_uv_now = Monitoring.user_visits('now', date)
      co_now = Monitoring.count_org('now', date)
      render json: {data:{x_cuv_now: x_cuv_now, y_cuv_now: y_cuv_now,
                          x_cpv_now: x_cpv_now, y_cpv_now: y_cpv_now,
                          x_uv_now: x_uv_now, y_uv_now: y_uv_now,
                          co_now: co_now,
                          time_now: time_now}}


    end
    if params[:week] == "true"
      first_day_week = ((DateTime.now+date.weeks).at_beginning_of_week-1.week).strftime("%d/%m/%Y")
      last_day_week = ((DateTime.now+date.weeks).at_end_of_week-1.week).strftime("%d/%m/%Y")
      time_week = first_day_week + '-'+last_day_week
      x_cuv_week, y_cuv_week = Monitoring.count_user_visits('week', date)
      x_cpv_week, y_cpv_week = Monitoring.count_path_visits('week', date)
      x_uv_week, y_uv_week = Monitoring.user_visits('week', date)
      co_week = Monitoring.count_org('week', date)
      render json: {data:{x_cuv_week: x_cuv_week, y_cuv_week: y_cuv_week,
                          x_cpv_week: x_cpv_week, y_cpv_week: y_cpv_week,
                          x_uv_week: x_uv_week, y_uv_week: y_uv_week, co_week: co_week,
                          time_week: time_week}}
    end
    if params[:month] == "true"
      first_day_month = ((DateTime.now+date.months).at_beginning_of_month).strftime("%d/%m/%Y")
      last_day_month = ((DateTime.now+date.months).at_end_of_month).strftime("%d/%m/%Y")
      time_month = first_day_month + '-'+last_day_month
      x_cuv_month, y_cuv_month = Monitoring.count_user_visits('month', date)
      x_cpv_month, y_cpv_month = Monitoring.count_path_visits('month', date)
      x_uv_month, y_uv_month = Monitoring.user_visits('month', date)
      co_month = Monitoring.count_org('month', date)
      render json: {data:{x_cuv_month: x_cuv_month, y_cuv_month: y_cuv_month,
                          x_cpv_month: x_cpv_month, y_cpv_month: y_cpv_month,
                          x_uv_month: x_uv_month, y_uv_month: y_uv_month,co_month: co_month,
                          time_month: time_month}}
    end



    # render json: {data:{labels_now: labels_now, values_now: values_now,
    #                             labels_week: labels_week, values_week: values_week,
    #                             labels_month: labels_month, values_month: values_month,
    #                             time_now: time_now, time_week: time_week, time_month: time_month}}


    respond_to do |format|
      format.json
      format.js
      format.html
    end


  end

end
