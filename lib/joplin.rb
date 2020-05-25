require "joplin/version"
require "faraday"
require "json"

module Joplin
  class Error < StandardError; end
  attr_accessor :token

  def self.token= token
    @@token = token
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

  class Notes
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

    private
    def parse response
      return if not response.body
      note = JSON.parse response.body
      @body = note['body']
      @title = note['title']
      @id = note["id"]
    end
  end
end
