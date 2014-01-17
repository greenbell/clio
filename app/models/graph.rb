require 'base64'
require 'open-uri'

class Graph
  def initialize
    @site = "http://0.0.0.0:5125/"
    @api = "graph"
    @service = ""
    @section = ""
  end

  def change_api(api)
    @api = api
    self
  end

  def select_service(service_name)
    @service = service_name
    self
  end

  def select_section(section_name)
    @section = section_name
    self
  end
  
  def set_name(name)
    @name = name
    self
  end

  def set_id(id)
    @id = id
    self
  end

  def get_graph(graph_name, params={})
    uri = "#{@site}#{@api}/#{@service}/#{@section}/#{graph_name}"
    uri += "?#{params.map{|k,v| "#{k}=#{v}"}.join('&')}" unless params.empty?
    begin
      open(uri) {|f|
        @dataurl = "data:image/png;base64,#{Base64.encode64(f.read).gsub("\n", "")}"
      }
      self
    rescue OpenURI::HTTPError
      @dataurl = nil
      self
    end
  end

  def dataurl
    @dataurl
  end

  def name
    @name
  end

  def id
    @id
  end
end
