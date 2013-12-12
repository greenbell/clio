# coding: utf-8
require 'spec_helper'

describe 'maillog' do
  def format_log(log)
    "#{log.server_name} #{log.daemon} #{log.time}"
  end
  subject { page }

  describe '#index' do
    let(:path) { maillog_index_path }
    it "shows log exactly" do
      log = create(:maillog, :today)
      visit path
      find("#maillog_table > tbody").should have_text(format_log(log))
    end

    it "paginates exactly" do
      logs = 31.times.map { create(:maillog, :today) }
      logs.sort_by! {|log| DateTime.now - log.time}
      visit maillog_index_path(:page => 2)
      find("#maillog_table > tbody").should have_text(format_log(logs[-1]))
      all(".pagination").first.should have_text("« First ‹ Prev 1 2")
    end

    context "when sorted by asc of time" do
      let(:path) { maillog_index_path(:sort => "a-time") }
      it "shows logs with sorted by asc of time" do
        logs = 5.times.map { create(:maillog, :today) }
        logs.sort_by! {|log| log.time }
        visit path
        logs.each_with_index do |log, i|
          find("#maillog_table > tbody > tr:nth-child(#{i+1})").should have_text(format_log(log))
        end
      end
    end

    context "when specified today" do
      let(:path) { maillog_index_path(:date => Date.today.strftime("%Y/%m/%d")) }
      it "shows only logs are created today" do
        today = create(:maillog, :today)
        dummy = create(:maillog, :time => rand(DateTime.now.to_f - Date.today.to_time.to_f).ago - 1.day)
        visit path
        within(:css, "#maillog_table") do
          should have_text(format_log(today))
          should_not have_text(format_log(dummy))
        end
      end
    end

    context "when filtered by server_name" do
      let(:log) { create(:maillog, :today) }
      let(:path) { maillog_index_path(:"filter[server_name]" => log.server_name) }
      it "shows only logs whose server_name is specified" do
        dummy = create(:maillog, :today)
        visit path
        within(:css, "#maillog_table") do
          should have_text(format_log(log))
          should_not have_text(format_log(dummy))
        end
      end
    end
  end
end
