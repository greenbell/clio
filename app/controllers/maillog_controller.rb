# coding: utf-8

class MaillogController < ApplicationController
  def index
    @logs = Maillog.set_session(params[:session])
                   .filter_by_datetime(params[:date], params[:time])
                   .filter_by_value(params[:filter])
                   .choose_order(params[:sort])
                   .page(params[:page])
                   .per(30)
  end
end
