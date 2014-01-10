# coding: utf-8

class RailsProductionController < ApplicationController
  def index
    if params[:filter]
      if params[:filter][:app].present?
        @graph = Graph.new.select_service(params[:session])
                          .select_section("rails.production")
                          .get_graph(params[:filter][:app])
      elsif params[:filter][:server_name].present?
        @graph = Graph.new.change_api("complex/graph")
                          .select_service(params[:session])
                          .select_section("rails.production")
                          .get_graph(params[:filter][:server_name])
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
