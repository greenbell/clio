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

  scope :datetime_filter, lambda {|datetime|
    datetime = (datetime)? Time.parse(datetime): Time.now - 5.minute
    self.where(:time.gt => datetime, :time.lt => datetime + 5.minute)
  }

  scope :value_filter, lambda {|params|
    if params
      params.delete_if {|key, value| value == ""}
      self.where(params)
    else
      nil
    end
  }

  scope :ok, -> { where(:code => "200") }
  scope :not_ok, -> { where(:code.ne => "200") }
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
  scope :options, -> { where(:method => "OPTIONS") }
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
    when "options"
      self.options
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
