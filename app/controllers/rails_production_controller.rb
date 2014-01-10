# coding: utf-8

class RailsProductionController < ApplicationController
  def index
    if params[:filter]
      if params[:filter][:app].present?
        @graph = Graph.select_service(params[:session])
                      .select_section("rails.production")
                      .find(params[:filter][:app])
      elsif params[:filter][:server_name].present?
        @graph = Graph.change_api("complex/graph")
                      .select_service(params[:session])
                      .select_section("rails.production")
                      .find(params[:filter][:server_name])
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
