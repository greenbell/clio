# coding: utf-8

class MaillogController < ApplicationController
  def index
    @graphs = Maillog.get_graphs(params)
    @logs = Maillog.set_session(params[:session])
                   .filter_by_datetime(params[:datetime])
                   .filter_by_value(params[:filter])
                   .choose_order(params[:sort])
                   .page(params[:page])
                   .per(30)
  end
end
