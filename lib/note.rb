class Note < ActiveRecord::Base
  belongs_to :memorable, :polymorphic => true
end
