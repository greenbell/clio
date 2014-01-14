# coding: utf-8

class MysqlSlowController < ApplicationController
  def index
    @graph = MysqlSlow.get_graph(params)
    @logs = MysqlSlow.set_session(params[:session])
                     .filter_by_datetime(params[:datetime])
                     .filter_by_value(params[:filter])
                     .choose_order(params[:sort])
                     .page(params[:page])
                     .per(30)
  end
end
