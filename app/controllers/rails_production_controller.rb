# coding: utf-8

class RailsProductionController < ApplicationController
  def index
    if params[:filter]
      if params[:filter][:app].present?
        @graph = Graph.select_service(params[:session])
                      .select_collection("rails.production")
                      .find(params[:filter][:app])
      end
    end
    @logs = RailsProduction.set_session(params[:session])
                           .filter_by_datetime(params[:datetime])
                           .filter_by_level(params[:level])
                           .filter_by_value(params[:filter])
                           .choose_order(params[:sort])
                           .page(params[:page])
                           .per(30)
  end
end
