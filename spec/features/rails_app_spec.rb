# coding: utf-8
require 'spec_helper'

describe 'rails_app' do
  def format_log(log)
    "#{log.server_name} #{log.time} #{log.level}"
  end
  subject { page }

  describe '#index' do
    let(:app_name) { Faker::Lorem.word }
    let(:path) { rails_app_index_path(:app => app_name) }
    before(:each) do
      RailsApp.set_app(app_name)
    end

    it "shows log exactly" do
      log = create(:rails_app, :today)
      visit path
      find("#rails_app_table > tbody").should have_text(format_log(log))
    end

    it "paginates exactly" do
      logs = 31.times.map { create(:rails_app, :today) }
      logs.sort_by! {|log| DateTime.now - log.time}
      visit rails_app_index_path(:app => app_name, :page => 2)
      find("#rails_app_table > tbody").should have_text(format_log(logs[-1]))
      all(".pagination").first.should have_text("« First ‹ Prev 1 2")
    end

    context "when sorted by asc of time" do
      let(:path) { rails_app_index_path(:app => app_name, :sort => "a-time") }
      it "shows logs with sorted by asc of time" do
        logs = 5.times.map { create(:rails_app, :today) }
        logs.sort_by! {|log| log.time }
        visit path
        logs.each_with_index do |log, i|
          find("#rails_app_table > tbody > tr:nth-child(#{i+1})").should have_text(format_log(log))
        end
      end
    end

    context "when specified today" do
      let(:path) { rails_app_index_path(:app => app_name, :date => Date.today.strftime("%Y/%m/%d")) }
      it "shows only logs are created today" do
        today = create(:rails_app, :today)
        dummy = create(:rails_app, :time => rand(DateTime.now.to_f - Date.today.to_time.to_f).ago - 1.day)
        visit path
        within(:css, "#rails_app_table") do
          should have_text(format_log(today))
          should_not have_text(format_log(dummy))
        end
      end
    end

    context "when filtered by level" do
      let(:log) { create(:rails_app, :today) }
      let(:path) { rails_app_index_path(:app => app_name, :"filter[level]" => log.level) }
      it "shows only logs whose level is specified" do
        dummy = create(:rails_app, :today)
        visit path
        within(:css, "#rails_app_table") do
          should have_text(format_log(log))
          should_not have_text(format_log(dummy))
        end
      end
    end
  end
end
