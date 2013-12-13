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

  def self.set_session(param)
    self.store_in :session => (param || "default")
    self
  end

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
