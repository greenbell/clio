# coding: utf-8
require 'spec_helper'

describe 'top' do
  def format_apache_access(log)
    "#{log.server_name} #{log.path} #{log.code} #{log.host} #{log.vhost} #{log.method} #{log.time} #{log.user} #{log.referer} #{log.agent} #{log.forwarded} #{log.size}"
  end

  def format_mysql_slow(log)
    "#{log.server_name} #{log.time} #{log.user} #{log.host} #{log.host_ip} #{log.query_time} #{log.lock_time} #{log.rows_sent} #{log.rows_examined} #{log.sql}"
  end

  subject { page }

  describe '#index' do
    let(:path) { root_path }
#   it "shows current 5 each logs" do
#     6.times do
#       create(:apache_access)
#       create(:mysql_slow)
#     end
#     visit path
#     within(:css, "#apache_access_table > tbody") do
#       should have_css("tr:nth-child(5)")
#       should_not have_css("tr:nth-child(6)")
#     end
#     within(:css, "#mysql_slow_table > tbody") do
#       should have_css("tr:nth-child(10)")
#       should_not have_css("tr:nth-child(11)")
#     end
#   end
  end
end
