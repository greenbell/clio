class RailsProduction
  include Mongoid::Document
  store_in :collection => "rails.production"
  field :time, :type => DateTime
  field :server_name
  field :level
  field :app
  field :messages, :type => Array

  def self.get_graphs(params)
    graphs = []
    if params[:filter]
      if params[:filter][:server_name].present? && params[:filter][:app].present?
        graphs.push Graph.new.set_name("#{params[:filter][:server_name]}.#{params[:filter][:app]}")
                             .set_id("server-app")
                             .select_service(params[:session])
                             .select_section("rails.production")
                             .get_graph("#{params[:filter][:server_name]}.#{params[:filter][:app]}")
      end
      if params[:filter][:app].present?
        graphs.push Graph.new.set_name(params[:filter][:app])
                             .set_id("app")
                             .change_api("complex/graph")
                             .select_service(params[:session])
                             .select_section("rails.production")
                             .get_graph(params[:filter][:app])
      end
      if params[:filter][:server_name].present?
        graphs.push Graph.new.set_name(params[:filter][:server_name])
                             .set_id("server")
                             .change_api("complex/graph")
                             .select_service(params[:session])
                             .select_section("rails.production")
                             .get_graph(params[:filter][:server_name])
      end
    end
    graphs
  end


  def self.set_session(param)
    store_in :session => (param || "default")
    self
  end

  scope :filter_by_datetime, lambda {|datetime|
    datetime = (datetime)? Time.parse(datetime): Time.now - 15.minute
    self.where(:time.gt => datetime, :time.lt => datetime + 15.minute)
  }

  scope :filter_by_level, lambda {|level|
    if level.present?
      self.where(:level => level)
    else
      nil 
    end
  }

  scope :filter_by_value, lambda {|params|
    if params
      params.delete_if {|key, value| value == ""}
      self.where(params)
    else
      nil
    end
  }

  scope :choose_order, lambda {|param|
    case param
    when "a-time"
      self.asc(:time)
    else
      self.desc(:time)
    end
  }
end
