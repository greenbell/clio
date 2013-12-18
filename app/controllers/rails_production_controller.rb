# coding: utf-8

class RailsProductionController < ApplicationController
  def index
    @logs = RailsProduction.set_session(params[:session])
                           .filter_by_date(params[:date])
                           .filter_by_level(params[:level])
                           .filter_by_value(params[:filter])
                           .choose_order(params[:sort])
                           .page(params[:page])
                           .per(30)
  end
end
