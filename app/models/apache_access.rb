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

  scope :ok, -> { where(:code => 200) }
  scope :not_ok, -> { where(:code.ne => 200) }
  scope :code_filter, lambda {|param|
    case param 
    when "all"
      nil
    when "ok"
      self.ok
    when "not_ok"
      self.not_ok
    end     
  }

  scope :get, -> { where(:method => "GET") }
  scope :post, -> { where(:method => "POST") }
  scope :put, -> { where(:method => "PUT") }
  scope :delete, -> { where(:method => "DELETE") }
  scope :method_filter, lambda {|param|
    case param
    when "all"
      nil
    when "get"
      self.get
    when "post"
      self.post
    when "put"
      self.put
    when "delete"
      self.delete
    end
  }

  scope :sort_chooser, lambda {|param|
    case param
    when "d-time"
      self.desc(:time)
    when "a-time"
      self.asc(:time)
    when "d-size"
      self.desc(:size)
    when "a-size"
      self.asc(:size)
    end
  }
end
