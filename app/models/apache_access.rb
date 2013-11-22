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
end
