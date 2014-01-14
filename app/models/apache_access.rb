class ApacheAccess
  include Mongoid::Document
  store_in collection: "apache.access"
  field :time, :type => DateTime
  field :vhost
  field :host
  field :user
  field :method
  field :path
  field :code
  field :size
  field :referer
  field :agent
  field :forwarded
  field :server_name

  def self.get_graphs(params)
    graphs = []
    graphs.push Graph.new.set_name("全サーバー - デイリー")
                         .set_id("all_daily")
                         .select_service(params[:session])
                         .select_section("apache")
                         .get_graph("access")
    graphs.push Graph.new.set_name("全サーバー - 毎時")
                         .set_id("all_hourly")
                         .select_service(params[:session])
                         .select_section("apache")
                         .get_graph("access", :t => "sh")
    graphs.delete(nil)
    graphs
  end

  def self.set_session(param)
    store_in :session => (param || "default")
    self
  end

  scope :filter_by_datetime, lambda {|datetime|
    datetime = (datetime)? Time.parse(datetime): Time.now - 5.minute
    self.where(:time.gt => datetime, :time.lt => datetime + 5.minute)
  }

  scope :filter_by_value, lambda {|params|
    if params
      params.delete_if {|key, value| value == ""}
      self.where(params)
    else
      nil
    end
  }

  scope :ok, -> { where(:code => "200") }
  scope :not_ok, -> { where(:code.ne => "200") }
  scope :filter_by_code, lambda {|param|
    case param
    when "ok"
      self.ok
    when "not_ok"
      self.not_ok
    else
      nil
    end     
  }

  scope :get, -> { where(:method => "GET") }
  scope :post, -> { where(:method => "POST") }
  scope :put, -> { where(:method => "PUT") }
  scope :delete, -> { where(:method => "DELETE") }
  scope :options, -> { where(:method => "OPTIONS") }
  scope :filter_by_method, lambda {|param|
    case param
    when "get"
      self.get
    when "post"
      self.post
    when "put"
      self.put
    when "delete"
      self.delete
    when "options"
      self.options
    else
      nil
    end
  }

  scope :choose_order, lambda {|param|
    case param
    when "a-time"
      self.asc(:time)
    when "d-size"
      self.desc(:size)
    when "a-size"
      self.asc(:size)
    else
      self.desc(:time)
    end
  }
end
