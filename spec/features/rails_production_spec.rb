# coding: utf-8
require 'spec_helper'

describe 'rails_production' do
  def format_log(log)
    "#{log.server_name} #{log.app} #{log.time} #{log.level}"
  end
  subject { page }

  describe '#index' do
    let(:path) { rails_production_index_path }
    it "shows log exactly" do
      log = create(:rails_production, :today)
      visit path
      find("#rails_production_table > tbody").should have_text(format_log(log))
    end

    it "paginates exactly" do
      logs = 31.times.map { create(:rails_production, :today) }
      logs.sort_by! {|log| DateTime.now - log.time}
      visit rails_production_index_path(:page => 2)
      find("#rails_production_table > tbody").should have_text(format_log(logs[-1]))
      all(".pagination").first.should have_text("« First ‹ Prev 1 2")
    end

    context "when sorted by asc of time" do
      let(:path) { rails_production_index_path(:sort => "a-time") }
      it "shows logs with sorted by asc of time" do
        logs = 5.times.map { create(:rails_production, :today) }
        logs.sort_by! {|log| log.time }
        visit path
        logs.each_with_index do |log, i|
          find("#rails_production_table > tbody > tr:nth-child(#{i+1})").should have_text(format_log(log))
        end
      end
    end

    context "when specified today" do
      let(:path) { rails_production_index_path(:date => Date.today.strftime("%Y/%m/%d")) }
      it "shows only logs are created today" do
        today = create(:rails_production, :today)
        dummy = create(:rails_production, :time => rand(DateTime.now.to_f - Date.today.to_time.to_f).ago - 1.day)
        visit path
        within(:css, "#rails_production_table") do
          should have_text(format_log(today))
          should_not have_text(format_log(dummy))
        end
      end
    end

    context "when filtered by level" do
      let(:log) { create(:rails_production, :today) }
      let(:path) { rails_production_index_path(:"filter[level]" => log.level) }
      it "shows only logs whose level is specified" do
        dummy = create(:rails_production, :today)
        visit path
        within(:css, "#rails_production_table") do
          should have_text(format_log(log))
          should_not have_text(format_log(dummy))
        end
      end
    end
  end
end
