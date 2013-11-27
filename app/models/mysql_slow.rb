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

  scope :sort_chooser, lambda {|param|
    case param
    when "d-time"
      self.desc(:time)
    when "a-time"
      self.asc(:time) 
    when "d-query"
      self.desc(:query_time)
    when "a-query"
      self.asc(:query_time) 
    when "d-lock"
      self.desc(:lock_time)
    when "a-lock"
      self.asc(:lock_time) 
    when "d-exam"
      self.desc(:rows_examined)
    when "a-exam"
      self.asc(:rows_examined) 
    when "d-sent"
      self.desc(:rows_sent)
    when "a-sent"
      self.asc(:rows_sent)
    end
  }
end
