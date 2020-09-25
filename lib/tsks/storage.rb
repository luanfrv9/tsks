require "sqlite3"

module Tsks
  class Storage
    def self.init
      storage = get_storage_instance
      storage.execute <<-SQL
        CREATE TABLE tsks (
          id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
          tsk VARCHAR NOT NULL,
          context VARCHAR DEFAULT Inbox,
          done BOOLEAN DEFAULT false,
          created_at VARCHAR NOT NULL,
          updated_at VARCHAR NOT NULL
        )
      SQL
    end

    def self.insert tsk, ctx=nil
      storage = get_storage_instance
      now = Time.now.strftime "%Y-%m-%e %H:%M:%S"

      if ctx
        storage.execute("
          INSERT INTO tsks (tsk, context, created_at, updated_at)
          VALUES (?, ?, ?, ?)",
          [tsk, ctx, now, now]
         )
      else
        storage.execute("
          INSERT INTO tsks (tsk, created_at, updated_at) VALUES (?, ?, ?)",
          [tsk, now, now]
         )
      end
    end

    def self.update id
      storage = get_storage_instance
      storage.execute "UPDATE tsks SET done=true WHERE id=?", id
    end

    private

    def self.get_storage_instance
      SQLite3::Database.new File.join CLI.setup_folder, "tsks.db"
    end
  end
end
