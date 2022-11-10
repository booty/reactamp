# frozen_string_literal: true

# Convenience wrappers for database access
class Db
  def self.execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end
end
