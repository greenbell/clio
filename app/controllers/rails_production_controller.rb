# coding: utf-8

class RailsProductionController < ApplicationController
  def index
    @graph = Graph.select_collection("rails.production").find(params[:filter][:app]) if params[:filter][:app].present? if params[:filter]
    @logs = RailsProduction.set_session(params[:session])
                           .filter_by_datetime(params[:datetime])
                           .filter_by_level(params[:level])
                           .filter_by_value(params[:filter])
                           .choose_order(params[:sort])
                           .page(params[:page])
                           .per(30)
  end
end
