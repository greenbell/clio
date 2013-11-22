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
end
