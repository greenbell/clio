# coding: utf-8
require 'spec_helper'

describe 'apache_access' do
  def format_log(log)
    "#{log.server_name} #{log.path} #{log.code} #{log.host} #{log.vhost} #{log.method} #{log.time} #{log.user} #{log.referer} #{log.agent} #{log.forwarded} #{log.size}"
  end
  subject { page }

  describe '#index' do
    let(:path) { log_path(:apache_access) }
    it "shows log exactly" do
      log = create(:apache_access, :recent)
      visit path
      find("#apache_access_table > tbody").should have_text(format_log(log))
    end

    it "paginates exactly" do
      logs = 31.times.map { create(:apache_access, :recent) }
      logs.sort_by! {|log| DateTime.now - log.time}
      visit log_path(:apache_access, :page => 2)
      find("#apache_access_table > tbody").should have_text(format_log(logs[-1]))
      all(".pagination").first.should have_text("« First ‹ Prev 1 2")
    end
    
    context "when specified status code" do
      shared_examples_for "specifying status code" do
        it "shows only logs that fulfill" do
          visit path
          within(:css, "#apache_access_table > tbody") do
            should have_text(format_log(log))
            should_not have_text(format_log(dummy))
          end
        end
      end

      context "200" do
        let(:path) { log_path(:apache_access, :code => "ok") }
        let!(:log) { create(:apache_access, :recent) }
        let!(:dummy) { create(:apache_access, :recent, :not_found) }
        include_examples "specifying status code"
      end

      context "without 200" do
        let(:path) { log_path(:apache_access, :code => "not_ok") }
        let!(:log) { create(:apache_access, :recent, :not_found) }
        let!(:dummy) { create(:apache_access, :recent) }
        include_examples "specifying status code"
      end
    end

    context "when specified http method" do
      let!(:methods) { ["get", "post", "put", "delete", "options"] }
      shared_examples_for "specifying http method" do
        it "shows only logs that fulfill" do
          visit path
          within(:css, "#apache_access_table > tbody") do
            should have_text(format_log(log))
            should_not have_text(format_log(dummy))
          end
        end
      end

      context "GET" do
        let(:path) { log_path(:apache_access, :method => "get") }
        let!(:log) { create(:apache_access, :recent) }
        let!(:dummy) { create(:apache_access, :recent, methods.reject{|v| v == nil}.sample.to_sym) }
        include_examples "specifying http method"
      end

      context "POST" do
        let(:path) { log_path(:apache_access, :method => "post") }
        let!(:log) { create(:apache_access, :recent, :post) }
        let!(:dummy) { create(:apache_access, :recent, methods.reject{|v| v == "post"}.sample.to_sym) }
        include_examples "specifying http method"
      end

      context "PUT" do
        let(:path) { log_path(:apache_access, :method => "put") }
        let!(:log) { create(:apache_access, :recent, :put) }
        let!(:dummy) { create(:apache_access, :recent, methods.reject{|v| v == "put"}.sample.to_sym) }
        include_examples "specifying http method"
      end

      context "DELETE" do
        let(:path) { log_path(:apache_access, :method => "delete") }
        let!(:log) { create(:apache_access, :recent, :delete) }
        let!(:dummy) { create(:apache_access, :recent, methods.reject{|v| v == "delete"}.sample.to_sym) }
        include_examples "specifying http method"
      end

      context "OPTIONS" do
        let(:path) { log_path(:apache_access, :method => "options") }
        let!(:log) { create(:apache_access, :recent, :options) }
        let!(:dummy) { create(:apache_access, :recent, methods.reject{|v| v == "options"}.sample.to_sym) }
        include_examples "specifying http method"
      end
    end

    context "when specified recent" do
      let(:path) { log_path(:apache_access, :date => 5.minute.ago.strftime("%Y/%m/%d")) }
      it "shows only logs are created recent" do
        recent = create(:apache_access, :recent)
        dummy = create(:apache_access, :time => rand(1.month - 5.minute).ago - 5.minute)
        visit path
        within(:css, "#apache_access_table > tbody") do
          should have_text(format_log(recent))
          should_not have_text(format_log(dummy))
        end
      end
    end

    context "when sorted by" do
      let!(:logs) { 5.times.map { create(:apache_access, :recent) }}
      shared_examples_for "sorting" do
        it "shows sorted logs" do
          logs.sort_by! &order
          visit path
          logs.each_with_index do |log, i|
            find("#apache_access_table > tbody > tr:nth-child(#{i+1})").should have_text(format_log(log))
          end
        end
      end

      context "asc of time" do
        let(:path) { log_path(:apache_access, :sort => "a-time") }
        let(:order) { lambda {|log| log.time }}
        include_examples "sorting"
      end

      context "desc of time" do
        let(:path) { log_path(:apache_access, :sort => "d-time") }
        let(:order) { lambda {|log| -log.time.to_f }}
        include_examples "sorting"
      end

#     FIXME: issue#10
#     context "asc of size" do
#       let(:path) { log_path(:apache_access, :sort => "a-size") }
#       let(:order) { lambda {|log| log.size }}
#       include_examples "sorting"
#     end

#     context "desc of time" do
#       let(:path) { log_path(:apache_access, :sort => "d-size") }
#       let(:order) { lambda {|log| -log.size }}
#       include_examples "sorting"
#     end
    end

    context "when filtered by value of" do
      let!(:log) { create(:apache_access, :recent) }
      let!(:dummy) { create(:apache_access, :recent) }
      shared_examples_for "filtering" do
        it "shows only logs that fulfill" do
          visit path
          within(:css, "#apache_access_table > tbody") do
            should have_text(format_log(log))
            should_not have_text(format_log(dummy))
          end
        end
      end

      context "server_name" do
        let(:path) { log_path(:apache_access, :"filter[server_name]" => log.server_name) }
        include_examples "filtering"
      end

      context "path" do
        let(:path) { log_path(:apache_access, :"filter[path]" => log.path) }
        include_examples "filtering"
      end

      context "host" do
        let(:path) { log_path(:apache_access, :"filter[host]" => log.host) }
        include_examples "filtering"
      end

      context "vhost" do
        let(:path) { log_path(:apache_access, :"filter[vhost]" => log.vhost) }
        include_examples "filtering"
      end

      context "user" do
        let(:path) { log_path(:apache_access, :"filter[user]" => log.user) }
        include_examples "filtering"
      end

      context "forwarded" do
        let(:path) { log_path(:apache_access, :"filter[forwarded]" => log.forwarded) }
        include_examples "filtering"
      end
    end
  end
end
