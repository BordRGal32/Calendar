require 'spec_helper'

describe Event do

  it { should have_many :notes }

  event_hash = {:name => "b", :description => "fun fun fun", :location => "my pants", :start_date => Date.parse("2014-02-27"), :end_date => Date.parse("2014-11-27")}
  event_hash2 = {:name => "a", :description => "fun fun not fun", :location => "my pants", :start_date => Date.parse("2011-03-28"), :end_date => Date.parse("2012-12-27")}
  event_hash3 = {:name => "c", :description => "fun fun fun", :location => "my pants", :start_date => Date.parse("2014-03-12"), :end_date => Date.parse("2014-03-13")}


  it {should validate_presence_of :start_date }
  it {should validate_presence_of :end_date}

  describe 'validate_start_before_end?' do
    it "should ensure that the start date is before the end date of the event" do
      e = Event.create(event_hash)
      e.valid?.should eq true
    end
  end

  describe 'sort_by_date' do
    it 'should sort dates in order of start date' do
      e = Event.create(event_hash)
      e2 = Event.create(event_hash2)
      Event.sort_by_date[0].should eq e2
    end
  end

  describe '.show_by_day' do
    it 'should show events for the current day' do
      e = Event.create(event_hash)
      Event.show_by_day(Date.today).should eq [e]
    end
  end

  # describe '.show_by_year' do
  #   it 'should show events for the current year' do
  #     e = Event.create(event_hash)
  #     e2 = Event.create(event_hash3)
  #     Event.show_by_year.should eq [e]
  #   end
  # end

  describe '.show_by_month' do
    it 'should show events for the current month' do
      e = Event.create(event_hash)
      e2 = Event.create(event_hash3)
      Event.show_by_month(Date.today).should eq [e2]
    end
  end


end
