# coding: utf-8

class ApacheAccessController < ApplicationController
  def index
    @logs = ApacheAccess.time_filter(params[:start], params[:end])
                        .value_filter(params[:filter])
                        .code_filter(params[:code])
                        .method_filter(params[:method])
                        .sort_chooser(params[:sort])
                        .page(params[:page])
                        .per(30)
  end
end
