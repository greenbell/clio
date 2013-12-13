# coding: utf-8

class ApacheAccessController < ApplicationController
  def index
    @logs = ApacheAccess.set_session(params[:session])
                        .datetime_filter(params[:datetime])
                        .value_filter(params[:filter])
                        .code_filter(params[:code])
                        .method_filter(params[:method])
                        .sort_chooser(params[:sort])
                        .page(params[:page])
                        .per(30)
  end
end
