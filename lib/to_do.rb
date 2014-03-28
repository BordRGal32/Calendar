class ToDo < ActiveRecord::Base

  has_many :notes, :as => :memorable

  def change_status
    if self.status == "not done"
      self.status = "completed"
    else
      self.status = "not done"
    end
    self.update(:status => self.status)
  end
end
