require "joplin/version"
require "faraday"
require "json"

module Joplin
  class Error < StandardError; end
  attr_accessor :token

  def self.token= token
    @@token = token
  end

  def self.search(query, opts = {})
    url = "#{Joplin::uri}/search/?query=#{query}&token=#{Joplin::token}&type=#{opts[:type]}"
    res = Faraday.get url
    parsed = JSON.parse res.body
    return parsed
  end

  def self.token
    @@token
  end

  def self.uri= uri
    @@uri = uri
  end

  def self.uri
    @@uri
  end

  self.uri = "http://localhost:41184"

  class Resource
    attr_reader :id

    def self.all
        url = "#{Joplin::uri}/resources/?token=#{Joplin::token}&fields=id"
        res = Faraday.get url
        parsed = JSON.parse res.body
        if res.status != 200
          throw Error.new(parsed['error'])
        end
        parsed.map do |resource|
          Resource.new resource['id']
        end
    end

    def initialize(id=nil)

      raise Error.new("need id") unless id
      @id = id
      url = "#{Joplin::uri}/resources/#{id}?token=#{Joplin::token}&fields=mime,filename,id"
      res = Faraday.get url
      @parsed = JSON.parse res.body
    end

    def delete
      url = "#{Joplin::uri}/resources/#{id}?token=#{Joplin::token}"
      res = Faraday.delete url
      res.status == 200
    end

    def to_s
      """id: #{@id},
mime: #{@parsed['mime']}
filename: #{@parsed['filename']}"""
    end

    def self.orphaned
      resources = all.map { |r| r.id }
      note_resources = Note.all.map { |n| n.resources }.flatten.map { |r| r.id }
      resources.difference(note_resources).map { |id| Resource.new id }
    end
  end

  class Note
    attr_accessor :body
    attr_accessor :title
    attr_reader :id

    def initialize(id=nil)

      @id = id
      if id
        url = "#{Joplin::uri}/notes/#{id}?token=#{Joplin::token}&fields=title,body,id"
        parse Faraday.get url
      end
    end

    def resources
        url = "#{Joplin::uri}/notes/#{id}/resources?token=#{Joplin::token}&fields=id"
        res = Faraday.get url
        parsed = JSON.parse res.body
        parsed.map do |resource_data|
          id = resource_data['id']
          Resource.new id
        end
    end

    def to_json
      {
        title: @title,
        body: @body
      }.to_json
    end

    def save!
      if @id
        url = "#{Joplin::uri}/notes/#{@id}?token=#{Joplin::token}"
        response = Faraday.put url, self.to_json
        return response.status == 200
      end

        url = "#{Joplin::uri}/notes/?token=#{Joplin::token}"
        parse Faraday.post url, self.to_json
    end

    def to_s
      """id: #{self.id}
title: #{self.title}
body: #{self.body}"""
    end

    def self.all
        url = "#{Joplin::uri}/notes/?token=#{Joplin::token}&fields=id"
        res = Faraday.get url
        parsed = JSON.parse res.body
        parsed.map do |note|
          Note.new note['id']
        end
    end

    private
    def parse response
      return if not response.body
      note = JSON.parse response.body
      if response.status != 200
        raise Error.new note["error"]
      end
      @body = note['body']
      @title = note['title']
      @id = note["id"]
    end
  end

  class Notebook
    def initialize(id=nil)

      @id = id
      if id
        url = "#{Joplin::uri}/folders/#{id}?token=#{Joplin::token}"
        res = Faraday.get url
        parsed = JSON.parse res.body
      end
    end

    def notes
      url = "#{Joplin::uri}/folders/#{@id}/notes?token=#{Joplin::token}"
      res = Faraday.get url
      notes = JSON.parse res.body
      notes.map! { |n| Joplin::Note.new n['id'] }
    end
  end
end
