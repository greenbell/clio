# coding: utf-8
require 'spec_helper'

describe 'maillog' do
  def format_log(log)
    "#{log.server_name} #{log.daemon} #{log.time}"
  end
  subject { page }

  describe '#index' do
    let(:path) { log_path(:maillog) }
    it "shows log exactly" do
      log = create(:maillog, :today)
      visit path
      find("#maillog_table > tbody").should have_text(format_log(log))
    end

    it "paginates exactly" do
      logs = 31.times.map { create(:maillog, :today) }
      logs.sort_by! {|log| DateTime.now - log.time}
      visit log_path(:maillog, :page => 2)
      find("#maillog_table > tbody").should have_text(format_log(logs[-1]))
      all(".pagination").first.should have_text("« First ‹ Prev 1 2")
    end

    context "when sorted by" do
      let!(:logs) { 5.times.map { create(:maillog, :today) }}
      shared_examples_for "sorting" do
        it "shows sorted logs" do
          logs.sort_by! &order
          visit path
          logs.each_with_index do |log, i|
            find("#maillog_table > tbody > tr:nth-child(#{i+1})").should have_text(format_log(log))
          end
        end
      end

      context "asc of time" do
        let(:path) { log_path(:maillog, :sort => "a-time") }
        let(:order) { lambda {|log| log.time }}
        include_examples "sorting"
      end

      context "desc of time" do
        let(:path) { log_path(:maillog, :sort => "d-time") }
        let(:order) { lambda {|log| -log.time.to_f }}
        include_examples "sorting"
      end
    end

    context "when filtered by today" do
      let(:path) { log_path(:maillog, :date => Date.today.strftime("%Y/%m/%d")) }
      it "shows only logs are created today" do
        today = create(:maillog, :today)
        dummy = create(:maillog, :time => rand(DateTime.now.to_f - Date.today.to_time.to_f).ago - 1.day)
        visit path
        within(:css, "#maillog_table > tbody") do
          should have_text(format_log(today))
          should_not have_text(format_log(dummy))
        end
      end
    end

    context "when filtered by value of" do
      let!(:log) { create(:maillog, :today) }
      let!(:dummy) { create(:maillog, :today) }
      shared_examples_for "filtering" do
        it "shows only logs that fulfill" do
          visit path
          within(:css, "#maillog_table > tbody") do
            should have_text(format_log(log))
            should_not have_text(format_log(dummy))
          end
        end
      end

      context "server_name" do
        let(:path) { log_path(:maillog, :"filter[server_name]" => log.server_name) }
        include_examples "filtering"
      end

      context "daemon" do
        let(:path) { log_path(:maillog, :"filter[daemon]" => log.daemon) }
        include_examples "filtering"
      end
    end
  end
end
