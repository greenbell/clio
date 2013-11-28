# coding: utf-8

class ApacheAccessController < ApplicationController
  def index
    @start = (params[:start])? params[:start]: (DateTime.now - 1.month).strftime("%Y/%m/%d %H:%M:%S")
    @end = (params[:end])? params[:end]: DateTime.now.strftime("%Y/%m/%d %H:%M:%S")
    @logs = ApacheAccess.where(:time.gt => @start, :time.lt => @end).value_filter(params[:filter])

    @code = (params[:code])? params[:code]: "all"
    @logs = @logs.code_filter(@code)

    @method = (params[:method])? params[:method]: "all"
    @logs = @logs.method_filter(@method)
        
    @sort = (params[:sort])? params[:sort]: "d-time"
    @logs = @logs.sort_chooser(@sort)
  end
end
