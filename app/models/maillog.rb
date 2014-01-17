class Maillog
  include Mongoid::Document
  store_in collection: "maillog"
  field :time, :type => DateTime
  field :server_name
  field :daemon

  def self.get_graphs(params)
    graphs = []
    if params[:filter]
      if params[:filter][:server_name].present?
        graphs.push Graph.new.set_name("#{params[:filter][:server_name]} - デイリー")
                             .set_id("server_daily")
                             .select_service(params[:session])
                             .select_section("maillog")
                             .get_graph(params[:filter][:server_name])
      end
    end
    graphs.push Graph.new.set_name("全サーバー - デイリー")
                         .set_id("all_daily")
                         .change_api("complex/graph")
                         .select_service(params[:session])
                         .select_section("maillog")
                         .get_graph("all")
    graphs.push Graph.new.set_name("全サーバー - 毎時")
                         .set_id("all_hourly")
                         .change_api("complex/graph")
                         .select_service(params[:session])
                         .select_section("maillog")
                         .get_graph("all", :t => "sh")
    graphs
  end

  def self.set_session(param)
    store_in :session => (param || "default")
    self
  end

  scope :filter_by_datetime, lambda {|datetime|
    datetime = (datetime)? Time.parse(datetime): Time.now - 1.hour
    self.where(:time.gt => datetime, :time.lt => datetime + 1.hour)
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
