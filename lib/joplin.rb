require 'joplin/version'
require 'http'
require 'json'

# https://joplinapp.org/api/overview/
module Joplin
  class Error < StandardError; end
  attr_accessor :token

  @@token = nil

  def self.token=(token)
    @@token = token
  end

  def self.search(query, opts = {})
    url = "#{Joplin.uri}/search/?query=#{query}&token=#{Joplin.token}&type=#{opts[:type]}"
    res = HTTP.get url
    JSON.parse res.body
  end

  def self.get_token
    settings = JSON.parse File.read("#{ENV['HOME']}/.config/joplin-desktop/settings.json")
    settings['api.token']
  rescue StandardError
    nil
  end

  def self.token
    @@token || get_token
  end

  def self.uri=(uri)
    @@uri = uri
  end

  def self.uri
    @@uri
  end

  self.uri = 'http://localhost:41184'

  class Resource
    class NotFound < Joplin::Error; end
    attr_reader :id, :filename, :mime

    def self.all
      url = "#{Joplin.uri}/resources/?token=#{Joplin.token}&fields=id,filename"
      response = HTTP.get url

      parsed = JSON.parse res.body
      throw Error.new(parsed['error']) if response.status != 200
      parsed.map do |resource|
        Resource.new resource['id']
      end
    end

    def initialize(id)
      raise Error, 'need id' unless id

      @id = id
      url = "#{Joplin.uri}/resources/#{id}?token=#{Joplin.token}&fields=mime,filename,id"
      response = HTTP.get url
      raise NotFound, "No resource found with id: #{id}" if response.code == 404

      resource = @parsed = JSON.parse response.body
      @filename = resource['filename']
      @mime = resource['mime']
    end

    def file
      url = "#{Joplin.uri}/resources/#{id}/file?token=#{Joplin.token}"
      response = HTTP.get url
      throw Error if response.status != 200
      response.body
    end

    def write(path = nil)
      IO.write path || id, file
    end

    def delete
      url = "#{Joplin.uri}/resources/#{id}?token=#{Joplin.token}"
      res = HTTP.delete url
      res.status == 200
    end

    def to_s
      %(id: #{id}, mime: #{mime} filename: #{filename})
    end

    def self.orphaned
      resources = all.map { |r| r.id }
      note_resources = Note.all.map { |n| n.resources }.flatten.map { |r| r.id }
      resources.difference(note_resources).map { |id| Resource.new id }
    end
  end

  class Note
    class NotFound < Joplin::Error; end

    attr_accessor :body, :title, :parent_id
    attr_reader :id

    def initialize(id: nil, parent_id: nil)
      @id = id
      @parent_id = parent_id
      return unless id

      url = "#{Joplin.uri}/notes/#{id}?token=#{Joplin.token}&fields=title,body,id,parent_id"
      parse HTTP.get url
    end

    def resources
      url = "#{Joplin.uri}/notes/#{id}/resources?token=#{Joplin.token}&fields=id,filename"
      response = HTTP.get url
      raise Error, "#{response}" if response.code != 200

      parsed = JSON.parse response.body
      parsed['items'].map do |resource_data|
        id = resource_data['id']
        Resource.new id
      end
    end

    def prepare_body_for_writing_by_fixing_resources
      prepared = String(body)
      prepared.each_line do |line|
      end
    end

    def write(path = nil)
      dir = path || title
      Dir.mkdir dir
      Dir.mkdir "#{dir}/resources"
      body_to_write = String(body) # make a copy
      resources.each do |resource|
        resource.write "#{dir}/resources/#{resource.id}"
        body_to_write.gsub!(%r{:/#{resource.id}}, "./resources/#{resource.id}")
      end
      IO.write "#{dir}/#{title}.md", body_to_write
    end

    def to_json(*_args)
      {
        title:,
        body:,
        parent_id:
      }.to_json
    end

    def save!
      if @id
        url = "#{Joplin.uri}/notes/#{@id}?token=#{Joplin.token}"
        response = HTTP.put url, body: to_json
        return response.status == 200
      end

      url = "#{Joplin.uri}/notes/?token=#{Joplin.token}"
      parse HTTP.post url, body: to_json
    end

    def to_s
      %(id: #{id} title: #{title} parent_id: #{parent_id} body: #{body})
    end

    def self.all
      url = "#{Joplin.uri}/notes/?token=#{Joplin.token}&fields=id"
      res = HTTP.get url
      parsed = JSON.parse res.body
      parsed.map do |note|
        Note.new note['id']
      end
    end

    def delete!
      url = "#{Joplin.uri}/notes/#{@id}?token=#{Joplin.token}"
      response = HTTP.delete url
      response.status == 200
    end

    private

    def parse(response)
      raise "No note found with id #{@id}" if response.body.empty?

      note = JSON.parse response.body
      raise NotFound, "No note found with id: #{id}" if response.code == 404
      raise Error, "#{note['error']}\nid: #{id}" if response.code != 200

      @body = note['body']
      @title = note['title']
      @id = note['id']
      @parent_id = note['parent_id']
    end
  end

  class Notebook
    def initialize(id = nil)
      @id = id
      return unless id

      url = "#{Joplin.uri}/folders/#{id}?token=#{Joplin.token}"
      res = HTTP.get url
      parsed = JSON.parse res.body
    end

    def notes
      url = "#{Joplin.uri}/folders/#{@id}/notes?token=#{Joplin.token}"
      res = HTTP.get url
      notes = JSON.parse res.body
      notes.map! { |n| Joplin::Note.new n['id'] }
    end
  end
end
