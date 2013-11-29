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
  field :size, :type => Integer
  field :referer
  field :agent
  field :forwarded
  field :server_name

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

  scope :ok, -> { where(:code => 200) }
  scope :not_ok, -> { where(:code.ne => 200) }
  scope :code_filter, lambda {|param|
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
  scope :method_filter, lambda {|param|
    case param
    when "get"
      self.get
    when "post"
      self.post
    when "put"
      self.put
    when "delete"
      self.delete
    else
      nil
    end
  }

  scope :sort_chooser, lambda {|param|
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
