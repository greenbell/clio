# coding: utf-8

class ApacheAccessController < ApplicationController
  def index
    @start = (params[:start])? params[:start]: (DateTime.now - 1.month).strftime("%Y/%m/%d %H:%M:%S")
    @end = (params[:end])? params[:end]: DateTime.now.strftime("%Y/%m/%d %H:%M:%S")
    @logs = ApacheAccess.where(:time.gt => @start, :time.lt => @end).desc(:time).limit(20)
  end
end
