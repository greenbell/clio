class MysqlSlow
  include Mongoid::Document
  store_in :collection => "mysql.slow"
  field :server_name
  field :time, :type => DateTime
  field :user
  field :host
  field :host_ip
  field :query_time
  field :lock_time
  field :rows_sent
  field :rows_examined
  field :sql

  scope :time_filter, lambda {|start_time, end_time|
    start_time = (DateTime.now - 1.month).strftime("%Y/%m/%d %H:%M:%S") unless start_time
    end_time = DateTime.now.strftime("%Y/%m/%d %H:%M:%S") unless end_time
    self.where(:time.gt => start_time, :time.lt => end_time)
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
