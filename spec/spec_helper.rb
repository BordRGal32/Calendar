require 'rspec'
require 'active_record'
require 'event'
require 'note'
require 'to_do'
require 'shoulda-matchers'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
  Event.all.each { |event| event.destroy}
  ToDo.all.each { |todo| todo.destroy }
  Note.all.each { |note| note.destory }
  end
end
