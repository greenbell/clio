# coding: utf-8

class MysqlSlowController < ApplicationController
  def index
    @start = (params[:start])? params[:start]: (DateTime.now - 1.month).strftime("%Y/%m/%d %H:%M:%S")
    @end = (params[:end])? params[:end]: DateTime.now.strftime("%Y/%m/%d %H:%M:%S")
    @logs = MysqlSlow.where(:time.gt => @start, :time.lt => @end)

    @sort = (params[:sort])? params[:sort]: "d-time"
    @logs = @logs.sort_chooser(@sort)
  end
end
