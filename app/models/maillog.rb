class Maillog
  include Mongoid::Document
  store_in collection: "maillog"
  field :time, :type => DateTime
  field :server_name
  field :daemon

  def self.set_session(param)
    store_in :session => (param || "default")
    self
  end

  scope :filter_by_datetime, lambda {|datetime|
    datetime = (datetime)? DateTime.parse(datetime): DateTime.now - 1.hour
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
