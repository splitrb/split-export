require 'spec_helper'

describe Split::Export do
  before :each do
    experiment = Split::Experiment.find_or_create('link_color', 'blue', 'red', 'green')
    blue = Split::Alternative.find('blue', 'link_color')
    blue.participant_count = 5
    blue.completed_count = 3
    blue.save
    red = Split::Alternative.find('red', 'link_color')
    red.participant_count = 6
    red.completed_count = 4
    red.save
  end

  it "should generate a csv of split data" do
    Split::Export.to_csv.should eql("Experiment,Alternative,Participants,Completed,Conversion Rate,Z score,Control,Winner\nlink_color,blue,5,3,0.6,0.0,true,false\nlink_color,red,6,4,0.667,0.215,false,false\n")
  end
end