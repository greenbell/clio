class Maillog
  include Mongoid::Document
  store_in collection: "maillog"
  field :time, :type => DateTime
  field :server_name
  field :daemon
  field :proc_name
  field :proc_no

  scope :date_filter, lambda {|date|
    date = (date)? Date.parse(date): Date.today 
    self.where(:time.gt => date, :time.lt => date + 1.day)
  }

  scope :value_filter, lambda {|params|
    if params
      params.delete_if {|key, value| value == ""}
      self.where(params)
    else
      nil
    end
  }

  scope :sort_chooser, lambda {|param|
    case param
    when "a-time"
      self.asc(:time)
    else
      self.desc(:time)
    end
  }
end
