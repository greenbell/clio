# coding: utf-8

class ApacheAccessController < ApplicationController
  def index
    @logs = ApacheAccess.set_session(params[:session])
                        .filter_by_datetime(params[:datetime])
                        .filter_by_value(params[:filter])
                        .filter_by_code(params[:code])
                        .filter_by_method(params[:method])
                        .choose_order(params[:sort])
                        .page(params[:page])
                        .per(30)
  end
end
