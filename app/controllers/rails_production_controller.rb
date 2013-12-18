# coding: utf-8

class RailsProductionController < ApplicationController
  def index
    @logs = RailsProduction.set_session(params[:session])
                           .date_filter(params[:date])
                           .level_filter(params[:level])
                           .value_filter(params[:filter])
                           .sort_chooser(params[:sort])
                           .page(params[:page])
                           .per(30)
  end
end
