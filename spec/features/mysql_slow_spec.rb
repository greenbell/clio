# coding: utf-8
require 'spec_helper'

describe 'mysql_slow' do
  def format_log(log)
    "#{log.server_name} #{log.time} #{log.user} #{log.host} #{log.host_ip} #{log.query_time} #{log.lock_time} #{log.rows_sent} #{log.rows_examined} #{log.sql}"
  end
  subject { page }

  describe '#index' do
    let(:path) { mysql_slow_index_path }
    it "shows log exactly" do
      log = create(:mysql_slow)
      visit path
      find("#mysql_slow_table > tbody").should have_text(format_log(log))
    end
    context "when sorted by asc of lock_time" do
      let(:path) { mysql_slow_index_path(:sort => "a-lock_time") }
      it "shows logs with sorted by asc of lock_time" do
        logs = 5.times.map {
          create(:mysql_slow)
        }
        logs.sort_by! {|log| log.lock_time }
        visit path
        logs.each_with_index do |log, i|
          find("#mysql_slow_table > tbody > tr:nth-child(#{i+1})").should have_text(format_log(log))
        end
      end
    end
  end
end
