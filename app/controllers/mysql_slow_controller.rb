# coding: utf-8

class MysqlSlowController < ApplicationController
  def index
    @logs = MysqlSlow.time_filter(params[:start], params[:end])
                     .value_filter(params[:filter])
                     .sort_chooser(params[:sort])
                     .page(params[:page])
                     .per(30)
  end
end
