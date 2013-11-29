# coding: utf-8

class MysqlSlowController < ApplicationController
  def index
    @logs = MysqlSlow.date_filter(params[:date])
                     .value_filter(params[:filter])
                     .sort_chooser(params[:sort])
                     .page(params[:page])
                     .per(30)
  end
end
