module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :uuid

   def connect
     self.uuid = SecureRandom.uuid
     logger.add_tags "ActionCable", "User #{self.uuid}"
   end

  end
end
