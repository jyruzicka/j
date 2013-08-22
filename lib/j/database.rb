module J::Database
  

  class << self  
    def path
      @path ||= File.join(ENV['HOME'],".j/db.sqlite3")
    end

    def path= p
      @path = p
    end

    def connect
      ActiveRecord::Base.establish_connection(adapter:"sqlite3", database:path)
    end

    def migrations_folder
      @migrations_folder ||= File.join(J::ROOT, "j/migrate")
    end

    def ensure_latest_version!
      ActiveRecord::Migrator.migrate(migrations_folder, nil)
    end
  end
end