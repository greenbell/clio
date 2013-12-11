# coding: utf-8
require 'spec_helper'

describe 'mysql_slow' do
  def format_log(log)
    "#{log.server_name} #{log.time} #{log.user} #{log.host} #{log.host_ip} #{log.query_time} #{log.lock_time} #{log.rows_sent} #{log.rows_examined}"
  end
  subject { page }

  describe '#index' do
    let(:path) { mysql_slow_index_path }
    it "shows log exactly" do
      log = create(:mysql_slow, :today)
      visit path
      find("#mysql_slow_table > tbody").should have_text(format_log(log))
    end

    it "paginates exactly" do
      logs = 31.times.map { create(:mysql_slow, :today) }
      logs.sort_by! {|log| DateTime.now - log.time}
      visit mysql_slow_index_path(:page => 2)
      find("#mysql_slow_table > tbody").should have_text(format_log(logs[-1]))
      all(".pagination").first.should have_text("« First ‹ Prev 1 2")
    end

    context "when sorted by asc of lock_time" do
      let(:path) { mysql_slow_index_path(:sort => "a-lock_time") }
      it "shows logs with sorted by asc of lock_time" do
        logs = 5.times.map { create(:mysql_slow, :today) }
        logs.sort_by! {|log| log.lock_time }
        visit path
        logs.each_with_index do |log, i|
          find("#mysql_slow_table > tbody > tr:nth-child(#{2*i+1})").should have_text(format_log(log))
        end
      end
    end

    context "when specified today" do
      let(:path) { mysql_slow_index_path(:date => Date.today.strftime("%Y/%m/%d")) }
      it "shows only logs are created today" do
        today = create(:mysql_slow, :today)
        dummy = create(:mysql_slow, :time => rand(DateTime.now.to_f - Date.today.to_time.to_f).ago - 1.day)
        visit path
        within(:css, "#mysql_slow_table") do
          should have_text(format_log(today))
          should_not have_text(format_log(dummy))
        end
      end
    end

    context "when filtered by host" do
      let(:log) { create(:mysql_slow, :today) }
      let(:path) { mysql_slow_index_path(:"filter[host]" => log.host) }
      it "shows only logs whose host is specified" do
        dummy = create(:mysql_slow, :today)
        visit path
        within(:css, "#mysql_slow_table") do
          should have_text(format_log(log))
          should_not have_text(format_log(dummy))
        end
      end
    end
  end
end
