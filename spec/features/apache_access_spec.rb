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
      log = create(:apache_access, :recent)
      visit path
      find("#apache_access_table > tbody").should have_text(format_log(log))
    end

    it "paginates exactly" do
      logs = 31.times.map { create(:apache_access, :recent) }
      logs.sort_by! {|log| DateTime.now - log.time}
      visit apache_access_index_path(:page => 2)
      find("#apache_access_table > tbody").should have_text(format_log(logs[-1]))
      all(".pagination").first.should have_text("« First ‹ Prev 1 2")
    end
    
    context "when specified code 200" do
      let(:path) { apache_access_index_path(:code => "ok") }
      it "shows only logs whose code is 200" do
        ok = create(:apache_access, :recent)
        not_found = create(:apache_access, :recent, :not_found)
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
        get = create(:apache_access, :recent)
        post = create(:apache_access, :post, :recent)
        visit path
        within(:css, "#apache_access_table") do
          should have_text(format_log(post))
          should_not have_text(format_log(get))
        end
      end
    end

#   context "when specified today" do
#     let(:path) { apache_access_index_path(:date => Date.today.strftime("%Y/%m/%d")) }
#     it "shows only logs are created today" do
#       today = create(:apache_access, :recent)
#       dummy = create(:apache_access, :time => rand(DateTime.now.to_f - Date.today.to_time.to_f).ago - 1.day)
#       visit path
#       within(:css, "#apache_access_table") do
#         should have_text(format_log(today))
#         should_not have_text(format_log(dummy))
#       end
#     end
#   end

    context "when sorted by asc of datetime" do
      let(:path) { apache_access_index_path(:sort => "a-time")}
      it "shows logs with sorted by asc of datetime" do
        logs = 5.times.map { create(:apache_access, :recent) }
        logs.sort_by! {|log| log.time}
        visit path
        logs.each_with_index do |log, i|
          find("#apache_access_table > tbody > tr:nth-child(#{i+1})").should have_text(format_log(log))
        end
      end
    end

    context "when filtered by server_name" do
      let(:log) { create(:apache_access, :recent) }
      let(:path) { apache_access_index_path(:"filter[server_name]" => log.server_name) }
      it "shows only logs whose server_name is specified" do
        dummy = create(:apache_access, :recent)
        visit path
        within(:css, "#apache_access_table") do
          should have_text(format_log(log))
          should_not have_text(format_log(dummy))
        end
      end
    end
  end
end
