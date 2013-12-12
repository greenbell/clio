# coding: utf-8

class RailsAppController < ApplicationController
  def index
    RailsApp.set_app(params[:app])
    @logs = RailsApp.date_filter(params[:date])
                    .value_filter(params[:filter])
                    .sort_chooser(params[:sort])
                    .page(params[:page])
                    .per(30)
  end
end
