# coding: utf-8

class ApacheAccessController < ApplicationController
  def index
    @logs = ApacheAccess.datetime_filter(params[:date], params[:time])
                        .value_filter(params[:filter])
                        .code_filter(params[:code])
                        .method_filter(params[:method])
                        .sort_chooser(params[:sort])
                        .page(params[:page])
                        .per(30)
  end
end
