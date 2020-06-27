require "sqlite3"
module Joplin
  module Token
    def self.get
      begin
        db = SQLite3::Database.new "#{ENV['HOME']}/.config/joplin-desktop/database.sqlite"
        rows = db.execute("select value from settings where key='api.token';")
        return rows.flatten.first
      rescue
        return nil
      end
    end
  end
end
