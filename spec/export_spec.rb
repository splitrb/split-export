require 'spec_helper'

describe Split::Export do
  before :each do
    experiment = Split::ExperimentCatalog.find_or_create('link_color', 'blue', 'red', 'green')
    blue = Split::Alternative.new('blue', 'link_color')
    blue.participant_count = 5
    blue.set_completed_count(3)
    blue.save
    red = Split::Alternative.new('red', 'link_color')
    red.participant_count = 6
    red.set_completed_count(4)
    red.save
  end

  it "should generate a csv of split data" do
    Split::Export.to_csv.should eql("Experiment,Alternative,Participants,Completed,Conversion Rate,Z score,Control,Winner\nlink_color,blue,5,3,0.6,0.0,true,false\nlink_color,red,6,4,0.667,0.0,false,false\nlink_color,green,0,0,0.0,0.0,false,false\n")
  end
end
