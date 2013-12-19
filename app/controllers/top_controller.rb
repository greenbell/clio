# coding: utf-8

class TopController < ApplicationController
  def index
    @apache_access_logs = ApacheAccess.set_session("default").desc(:time).limit(5)
    @mysql_slow_logs = MysqlSlow.set_session("default").desc(:time).limit(5)
    @maillog_logs = Maillog.set_session("default").desc(:time).limit(5)
  end
end
