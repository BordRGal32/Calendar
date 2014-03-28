require 'active_record'
require './lib/event'
require './lib/to_do'
require './lib/note'
require 'pry'


ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

def welcome
puts "welcome to your calendar"
main
end

def main
  print ">"
  puts "type 'event' to look at your events 'x' to exit"
  puts "type 'to do' to look at your to do list"
  choice = gets.chomp
  case choice
  when 'event'
    event_helper
  when 'to do'
    to_do_helper
  when 'x'
    puts "goodbye"
    exit
  end
end

def event_main
 loop do
    print "event >"
    choice = gets.chomp
    case choice
    when 'add'
      add_event
    when 'delete'
      delete_event
    when 'list'
      list_events
    when 'edit'
      edit_event
    when 'current'
      current_menu
    when 'add note'
      add_note_event
    when 'help'
      event_helper
    when 'main'
      main
    end
  end
end

def event_helper
  puts "Type 'add' to add a new event"
  puts "Type 'delete' to delete an event"
  puts "Type 'edit' to edit an event"
  puts "Type 'list' to list all events"
  puts "Type 'current' to show current events"
  puts "Type 'add note' to add a note to an event"
  puts "Type 'main' to return to main menu"
  event_main
end

def add_event
  puts "Enter the event name:"
  name = gets.chomp
  puts "Enter the event description:"
  description = gets.chomp
  puts "Enter the event location:"
  location = gets.chomp
  puts "Enter the start date:"
  start_date = gets.chomp
  puts "Enter the end date:"
  end_date = gets.chomp
  puts "What time is the event?"
  time = gets.chomp

  new_event = Event.new({:name => name, :description => description, :location => location, :start_date => start_date, :end_date => end_date, :status => false, :time => time})

  if new_event.save
    puts "#{new_event.name} created"
  else
    puts "there were some errors:"
    new_event.errors.full_messages.each { |message| puts message}
  end
end

def delete_event
  event = find_event
  event.destroy
end

def event_details(event)
  puts "\nEvent Details:"
  puts "Name: #{event.name}"
  puts "Description: #{event.description}"
  puts "Location: #{event.location}"
  puts "Start Date: #{event.start_date}"
  puts "End Date: #{event.end_date}"
  puts "Event Time: #{event.time}"
end

def edit_event
  event = find_event
  event_details(event)
  puts "Enter the field you want to edit:"
  field = gets.chomp.downcase
  puts "Enter the new information:"
  new_info = gets.chomp
  puts "****"
  puts field
  if field == 'end date'
    field = 'end_date'
  elsif field == 'start date'
    field = 'start_date'
  end
  if event.update(field.to_sym => new_info)
    puts "#{event.name} has been updated"
  else
    event.errors.full_messages.each {|message| puts message}
  end
end

def current_menu
  puts "Type 'day' to see events by day"
  puts "Type 'week' to see events by week"
  puts "Type 'month' to see events by month"
  puts "Type 'year' to see events by year"
  todays_date = Date.today
  case gets.chomp
  when 'day'
    event_by_day(todays_date)
  when 'week'
    event_by_week(todays_date)
  when 'month'
    event_by_month(todays_date)
  when 'year'
    event_by_year(todays_date)
  end
end

def event_by_day(date)
  if Event.show_by_day(date).empty?
    puts "No events for this day."
  end
  Event.show_by_day(date).each {|event| puts event.name }
  puts "press 'next' to review the events for the next day enter the NAME of an event to review the full detials of that event"
  choice = gets.chomp.downcase
  if choice == 'next'
    date = date.next
    event_by_day(date)
  else
  event = Event.find_by(:name => choice)
  event_details(event)
  end
rescue
  puts "that was an invalid input"
  event_by_day(date)
end

def event_by_week(date)
  if Event.show_by_week(date).empty?
  puts "No events for this week."
  end
  Event.show_by_week(date).each {|event| puts event.name }
  puts "press 'next' to review the events for the next week enter the NAME of an event to review the full detials of that event"
  choice = gets.chomp.downcase
  if choice == 'next'
    date = date.next_day(7)
    event_by_day(date)
  else
  event = Event.find_by(:name => choice)
  event_details(event)
end
rescue
  puts "that was an invalid input"
  event_by_week(date)
end

def event_by_month(date)
  if Event.show_by_month(date).empty?
    puts "No events for this month."
  end
  Event.show_by_month(date).each {|event| puts event.name }
  puts "press 'next' to review the events for the next month enter the NAME of an event to review the full detials of that event"
  choice = gets.chomp.downcase
  if choice == 'next'
    date = date.next_month
    event_by_day(date)
  else
  event = Event.find_by(:name => choice)
  event_details(event)
end
rescue
  puts "that was an invalid input"
  event_by_month(date)
end

def event_by_year(date)
  if Event.show_by_year(date).empty?
    puts "No events for this year."
  end
  Event.show_by_year(date).each {|event| puts event.name }
  puts "press 'next' to review the events for the next year enter the NAME of an event to review the full detials of that event"
  choice = gets.chomp.downcase
  if choice == 'next'
    date = date.next_year
    event_by_day(date)
  else
  event = Event.find_by(:name => choice)
  event_details(event)
  end
  rescue
    puts "that was an invalid input"
    event_by_year(date)
end

def list_events
  puts "\nAll Events:"
  Event.sort_by_date.each { |event| puts event.name }
end

def find_event
 list_events
 puts "Enter the name of the target event"
 event = gets.chomp
 Event.find_by(:name => event)
end

def add_note_event
  event = find_event
  puts "Enter a  name for this note:"
  note_name = gets.chomp
  puts "Enter a description for this note"
  note_desc = gets.chomp
  event.notes.create({:name => note_name, :description => note_desc})
end

def to_do_main
  loop do
    print "to do >"
    choice = gets.chomp
    case choice
    when "add"
      add_to_do
    when 'list'
      list_to_do
    when 'complete'
      mark_task
    when 'add note'
      add_note_task
    when 'delete'
      delete_task
    when 'help'
      to_do_helper
    end
  end
end

def add_to_do
  puts "what is the name of your task"
  task_name = gets.chomp
  puts "enter a description for this task"
  task_desc = gets.chomp
  ToDo.create({:name => task_name, :description => task_desc, :status => "not done" })
end

def list_to_do
  ToDo.all.each { |task| puts task.name + ": " + task.description + " " + task.status + "\n"}
end

def find_task
  list_to_do
  puts "please enter the name of the task you are looking for"
  target_task = gets.chomp
  ToDo.find_by(:name => target_task)
end

def mark_task
  task = find_task
  task.change_status
  puts "#{task.name} has been marked as done"
end

def delete_task
  find_task.destroy
end

def add_note_task
  task = find_task
  puts "Enter a  name for this note:"
  note_name = gets.chomp
  puts "Enter a description for this note"
  note_desc = gets.chomp
  task.notes.create({:name => note_name, :description => note_desc})
end

def to_do_helper
puts "Type 'add' to add a new task to your to do list"
puts "Type 'list' to list all of your tasks - this list will also let you know if they are done"
puts "Type 'complete' to mark a task as done"
puts "Type 'add note' to add a note to a task"
puts "Type 'delete' to delete a task"
to_do_main
end

loop do
  main
end
