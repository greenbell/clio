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

  def get_graph(graph_name)
    uri = "#{@site}#{@api}/#{@service}/#{@section}/#{graph_name}"
    begin
      open(uri) {|f|
        @dataurl = "data:image/png;base64,#{Base64.encode64(f.read).gsub("\n", "")}"
      }
      self
    rescue OpenURI::HTTPError
      nil
    end
  end

  def dataurl
    @dataurl
  end
end
