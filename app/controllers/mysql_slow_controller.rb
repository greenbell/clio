# coding: utf-8

class MysqlSlowController < ApplicationController
  def index
    @logs = MysqlSlow.time_filter(params[:start], params[:end])
                     .sort_chooser(params[:sort])
  end
end
