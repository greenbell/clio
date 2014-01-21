# coding: utf-8

class TopController < ApplicationController
  def index
    @apache_access_graphs = ApacheAccess.get_graphs(params)
    @rails_production_graphs = RailsProduction.get_graphs(params)
    @mysql_slow_graphs = MysqlSlow.get_graphs(params)
    @maillog_graphs = Maillog.get_graphs(params)
  end
end
