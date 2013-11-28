# coding: utf-8
require 'spec_helper'

describe 'apache_access' do
  def format_log(log)
    "#{log.server_name} #{log.path} #{log.code} #{log.host} #{log.vhost} #{log.method} #{log.time} #{log.user} #{log.referer} #{log.agent} #{log.forwarded} #{log.size}"
  end
  subject { page }

  describe '#index' do
    let(:path) { apache_access_index_path }
    it "shows log exactly" do
      log = create(:apache_access)
      visit path
      find("#apache_access_table > tbody").should have_text(format_log(log))
    end
    
    context "when specified code 200" do
      let(:path) { apache_access_index_path(:code => "ok") }
      it "shows only logs whose code is 200" do
        ok = create(:apache_access)
        not_found = create(:apache_access, :not_found)
        visit path
        within(:css, "#apache_access_table") do
          should have_text(format_log(ok))
          should_not have_text(format_log(not_found))
        end
      end
    end

    context "when specified POST method" do
      let(:path) { apache_access_index_path(:method => "post") }
      it "shows only logs that is POST method" do
        get = create(:apache_access)
        post = create(:apache_access, :post)
        visit path
        within(:css, "#apache_access_table") do
          should have_text(format_log(post))
          should_not have_text(format_log(get))
        end
      end
    end

    context "when filtered by half month recently" do
      let(:path) { apache_access_index_path(:start => (DateTime.now - 15.day).strftime("%Y/%m/%d %H:%M:%S"))}
      it "shows only logs are created within half month" do
        week_ago = create(:apache_access, :time => 7.day.ago)
        three_weeks_ago = create(:apache_access, :time => 21.day.ago)
        visit path
        within(:css, "#apache_access_table") do
          should have_text(format_log(week_ago))
          should_not have_text(format_log(three_weeks_ago))
        end
      end
    end

    context "when sorted by asc of datetime" do
      let(:path) { apache_access_index_path(:sort => "a-time")}
      it "shows logs with sorted by asc of datetime" do
        logs = 5.times.map {
          create(:apache_access)
        }
        logs.sort_by! {|log| log.time}
        visit path
        logs.each_with_index do |log, i|
          find("#apache_access_table > tbody > tr:nth-child(#{i+1})").should have_text(format_log(log))
        end
      end
    end
  end
end
