require 'spec_helper'

describe ToDo do
  it { should have_many :notes }
end
