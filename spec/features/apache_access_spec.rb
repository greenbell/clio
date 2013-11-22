# coding: utf-8
require 'spec_helper'

describe 'apache_access' do
  subject { page }

  describe '#index' do
    let(:path) { apache_access_index_path }
    it "shows log exactly" do
      log = create(:apache_access)
      visit path
      find("#apache_access_table > tbody").should have_text("#{log.server_name} #{log.path} #{log.code} #{log.host} #{log.vhost} #{log.method} #{log.time} #{log.user} #{log.referer} #{log.agent} #{log.forwarded} #{log.size}")
    end

    it "shows", :focus => true do
      create(:apache_access)
      create(:apache_access)
      create(:apache_access)
      visit path
      save_and_open_page
    end
  end
end
