require "pry"
I18n.enforce_available_locales = true

class Event < ActiveRecord::Base
  has_many :notes, :as => :memorable

  validates :start_date, :presence => true
  validates :end_date, :presence => true

  validate :validate_start_before_end?


  def validate_start_before_end?
    if start_date != nil && end_date != nil
     if self.start_date > self.end_date
       errors.add(:start_date, "Enter valid start date")
     end
   end
  end
  def self.sort_by_date
    ordered_events = Event.order(:start_date)
    ordered_events
  end
  def self.show_by_year(date)
    events = []
    Event.all.each do |event|
      if event.start_date.year == date.year
        events << event
      end
    end
    events
  end
  def self.show_by_day(date)
    events = []
    Event.all.each do |event|
      if event.start_date.day == date.day
        events << event
      end
    end
    events
  end

  def self.show_by_week(date)
    events = []
    week = date.cweek
    Event.all.each do |event|
      if event.start_date.cweek == week && event.start_date.year == date.year
      events << event
      end
    end
    events
 end

  def self.show_by_month(date)
      events = []
    Event.all.each do |event|
      if event.start_date.month == date.month
        events << event
      end
    end
    events
  end
end
