class ApacheAccess
  include Mongoid::Document
  store_in collection: "apache.access"
  field :time, :type => DateTime
  field :vhost
  field :host
  field :user
  field :method
  field :path
  field :code, :type => Integer
  field :size
  field :referer
  field :agent
  field :forwarded
  field :server_name

  scope :ok, where(:code => 200)
  scope :not_ok, where(:code.ne => 200)

  scope :get, where(:method => "GET")
  scope :post, where(:method => "POST")
  scope :put, where(:method => "PUT")
  scope :delete, where(:method => "DELETE")
end
