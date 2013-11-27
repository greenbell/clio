# coding: utf-8

class ApacheAccessController < ApplicationController
  def index
    @start = (params[:start])? params[:start]: (DateTime.now - 1.month).strftime("%Y/%m/%d %H:%M:%S")
    @end = (params[:end])? params[:end]: DateTime.now.strftime("%Y/%m/%d %H:%M:%S")
    @logs = ApacheAccess.where(:time.gt => @start, :time.lt => @end)

    @code = (params[:code])? params[:code]: "all"
    @logs =
    case @code
      when "all"
        @logs
      when "ok"
        @logs.ok
      when "not_ok"
        @logs.not_ok
    end     

    @method = (params[:method])? params[:method]: "all"
    @logs =
    case @method
      when "all"
        @logs
      when "get"
        @logs.get
      when "post"
        @logs.post
      when "put"
        @logs.put
      when "delete"
        @logs.delete
    end
        
    @sort = (params[:sort])? params[:sort]: "d-time"
    @logs = 
    case @sort
    when "d-time"
      @logs.desc(:time)
    when "a-time"
      @logs.asc(:time) 
    end
  end
end
