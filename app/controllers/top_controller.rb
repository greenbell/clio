# coding: utf-8

class TopController < ApplicationController
  def index
    @apache_access_logs = ApacheAccess.desc(:time).limit(5)
    @mysql_slow_logs = MysqlSlow.desc(:time).limit(5)
  end
end
