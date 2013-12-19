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
      log = create(:maillog, :recent)
      visit path
      find("#maillog_table > tbody").should have_text(format_log(log))
    end

    it "paginates exactly" do
      logs = 31.times.map { create(:maillog, :recent) }
      logs.sort_by! {|log| DateTime.now - log.time}
      visit log_path(:maillog, :page => 2)
      find("#maillog_table > tbody").should have_text(format_log(logs[-1]))
      all(".pagination").first.should have_text("« First ‹ Prev 1 2")
    end

    context "when sorted by" do
      let!(:logs) { 5.times.map { create(:maillog, :recent) }}
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

    context "when filtered by recent" do
      let(:path) { log_path(:maillog) }
      it "shows only logs are created recent" do
        recent = create(:maillog, :recent)
        dummy = create(:maillog, :time => rand(DateTime.now.minute.minute).ago - 1.hour)
        visit path
        within(:css, "#maillog_table > tbody") do
          should have_text(format_log(recent))
          should_not have_text(format_log(dummy))
        end
      end
    end

    context "when filtered by value of" do
      let!(:log) { create(:maillog, :recent) }
      let!(:dummy) { create(:maillog, :recent) }
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
