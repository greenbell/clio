# coding: utf-8

class MaillogController < ApplicationController
  def index
    @logs = Maillog.set_session(params[:session])
                   .date_filter(params[:date])
                   .value_filter(params[:filter])
                   .sort_chooser(params[:sort])
                   .page(params[:page])
                   .per(30)
  end
end
