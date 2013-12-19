# coding: utf-8
require 'spec_helper'

describe 'mysql_slow' do
  def format_log(log)
    "#{log.server_name} #{log.time} #{log.user} #{log.host} #{log.host_ip} #{log.query_time} #{log.lock_time} #{log.rows_sent} #{log.rows_examined}"
  end
  subject { page }

  describe '#index' do
    let(:path) { log_path(:mysql_slow) }
    it "shows log exactly" do
      log = create(:mysql_slow, :recent)
      visit path
      find("#mysql_slow_table > tbody").should have_text(format_log(log))
    end

    it "paginates exactly" do
      logs = 31.times.map { create(:mysql_slow, :recent) }
      logs.sort_by! {|log| DateTime.now - log.time}
      visit log_path(:mysql_slow, :page => 2)
      find("#mysql_slow_table > tbody").should have_text(format_log(logs[-1]))
      all(".pagination").first.should have_text("« First ‹ Prev 1 2")
    end

    context "when sorted by" do
      let!(:logs) { 5.times.map { create(:mysql_slow, :recent) }}
      shared_examples_for "sorting" do
        it "shows sorted logs" do
          logs.sort_by! &order
          visit path
          logs.each_with_index do |log, i|
            find("#mysql_slow_table > tbody > tr:nth-child(#{2*i+1})").should have_text(format_log(log))
          end
        end
      end

      context "asc of time" do
        let(:path) { log_path(:mysql_slow, :sort => "a-time") }
        let(:order) { lambda {|log| log.time }}
        include_examples "sorting"
      end

      context "desc of time" do
        let(:path) { log_path(:mysql_slow, :sort => "d-time") }
        let(:order) { lambda {|log| -log.time.to_f }}
        include_examples "sorting"
      end

      context "asc of query_time" do
        let(:path) { log_path(:mysql_slow, :sort => "a-query_time") }
        let(:order) { lambda {|log| log.query_time }}
        include_examples "sorting"
      end

      context "desc of query_time" do
        let(:path) { log_path(:mysql_slow, :sort => "d-query_time") }
        let(:order) { lambda {|log| -log.query_time }}
        include_examples "sorting"
      end

      context "asc of lock_time" do
        let(:path) { log_path(:mysql_slow, :sort => "a-lock_time") }
        let(:order) { lambda {|log| log.lock_time }}
        include_examples "sorting"
      end

      context "desc of lock_time" do
        let(:path) { log_path(:mysql_slow, :sort => "d-lock_time") }
        let(:order) { lambda {|log| -log.lock_time }}
        include_examples "sorting"
      end

      context "asc of rows_sent" do
        let(:path) { log_path(:mysql_slow, :sort => "a-rows_sent") }
        let(:order) { lambda {|log| log.rows_sent }}
        include_examples "sorting"
      end

      context "desc of rows_sent" do
        let(:path) { log_path(:mysql_slow, :sort => "d-rows_sent") }
        let(:order) { lambda {|log| -log.rows_sent }}
        include_examples "sorting"
      end

      context "asc of rows_examined" do
        let(:path) { log_path(:mysql_slow, :sort => "a-rows_examined") }
        let(:order) { lambda {|log| log.rows_examined }}
        include_examples "sorting"
      end

      context "desc of rows_examined" do
        let(:path) { log_path(:mysql_slow, :sort => "d-rows_examined") }
        let(:order) { lambda {|log| -log.rows_examined }}
        include_examples "sorting"
      end
    end

    context "when filtered by recent" do
      let(:path) { log_path(:mysql_slow) }
      it "shows only logs are created recent" do
        recent = create(:mysql_slow, :recent)
        dummy = create(:mysql_slow, :time => rand(DateTime.now.minute.minute).ago - 1.hour)
        visit path
        within(:css, "#mysql_slow_table > tbody") do
          should have_text(format_log(recent))
          should_not have_text(format_log(dummy))
        end
      end
    end

    context "when filtered by value of" do
      let!(:log) { create(:mysql_slow, :recent) }
      let!(:dummy) { create(:mysql_slow, :recent) }
      shared_examples_for "filtering" do
        it "shows only logs that fulfill" do
          visit path
          within(:css, "#mysql_slow_table > tbody") do
            should have_text(format_log(log))
            should_not have_text(format_log(dummy))
          end
        end
      end

      context "server_name" do
        let(:path) { log_path(:mysql_slow, :"filter[server_name]" => log.server_name) }
        include_examples "filtering"
      end

      context "user" do
        let(:path) { log_path(:mysql_slow, :"filter[user]" => log.user) }
        include_examples "filtering"
      end

      context "host" do
        let(:path) { log_path(:mysql_slow, :"filter[host]" => log.host) }
        include_examples "filtering"
      end

      context "host_ip" do
        let(:path) { log_path(:mysql_slow, :"filter[host_ip]" => log.host_ip) }
        include_examples "filtering"
      end
    end
  end
end
