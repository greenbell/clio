require 'active_resource'
require 'base64'

class Graph < ActiveResource::Base
  class Format
    def extension() "" end
    def mime_type() "image/png" end
    def decode(image)
      {:dataurl => "data:image/png;base64,#{Base64.encode64(image).gsub("\n", "")}"}
    end
  end

  def self.element_path(id, prefix_options = {}, query_options = nil)
    prefix_options, query_options = split_options(prefix_options) if query_options.nil?
    "/#{@@api}/#{@@service}/#{@@section}/#{URI.escape id.to_s}#{query_string(query_options)}"
  end

  def self.find(arg)
    begin
      super(arg)
    rescue ActiveResource::ResourceNotFound
      nil
    end
  end

  def self.change_api(api)
    @@api = api
    self
  end

  def self.select_service(service_name)
    @@service = service_name
    self
  end

  def self.select_section(section_name)
    @@section = section_name
    self
  end

  @@api = "graph"
  self.site = "http://0.0.0.0:5125/"

  self.format = Format.new
  self.logger = Logger.new($stderr)
end
