class MysqlSlow
  include Mongoid::Document
  store_in :collection => "mysql.slow"
  field :server_name
  field :time, :type => DateTime
  field :user
  field :host
  field :host_ip
  field :query_time, :type => Float
  field :lock_time, :type => Float
  field :rows_sent, :type => Integer
  field :rows_examined, :type => Integer
  field :sql

  def self.get_graphs(params)
    graphs = []
    if params[:filter]
      if params[:filter][:server_name].present?
        graphs.push Graph.new.set_name("#{params[:filter][:server_name]} - デイリー")
                             .set_id("server_daily")
                             .select_service(params[:session])
                             .select_section("mysql.slow")
                             .get_graph(params[:filter][:server_name])
      end
    end
    graphs.push Graph.new.set_name("全サーバー - デイリー")
                         .set_id("all_daily")
                         .change_api("complex/graph")
                         .select_service(params[:session])
                         .select_section("mysql.slow")
                         .get_graph("all")
    graphs.push Graph.new.set_name("全サーバー - 毎時")
                         .set_id("all_hourly")
                         .change_api("complex/graph")
                         .select_service(params[:session])
                         .select_section("mysql.slow")
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
    when "d-query_time"
      self.desc(:query_time)
    when "a-query_time"
      self.asc(:query_time) 
    when "d-lock_time"
      self.desc(:lock_time)
    when "a-lock_time"
      self.asc(:lock_time) 
    when "d-rows_examined"
      self.desc(:rows_examined)
    when "a-rows_examined"
      self.asc(:rows_examined) 
    when "d-rows_sent"
      self.desc(:rows_sent)
    when "a-rows_sent"
      self.asc(:rows_sent)
    else
      self.desc(:time)
    end
  }
end
