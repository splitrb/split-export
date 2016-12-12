require 'spec_helper'

describe Split::Export do
  before :each do
    experiment = Split::ExperimentCatalog.find_or_create({'link_color': ["control", "goal"]}, 'blue', 'red', 'green')
    blue = Split::Alternative.new('blue', 'link_color')
    blue.participant_count = 5
    blue.set_completed_count(2, "control")
    blue.set_completed_count(1, "goal")
    blue.save
    red = Split::Alternative.new('red', 'link_color')
    red.participant_count = 6
    red.set_completed_count(2, "control")
    red.set_completed_count(2, "goal")
    red.save
  end

  it "should generate a csv of split data" do
    Split::Export.to_csv.should eql("Experiment,Alternative,Participants,Completed,Conversion Rate,Z score,Control,Winner\nlink_color,blue,5,3,0.6,0.0,true,false\nlink_color,red,6,4,0.667,0.0,false,false\nlink_color,green,0,0,0.0,0.0,false,false\n")
  end

  it "should generate a detailed csv of split data for a single table" do
    Split::Export.experiment_to_csv("link_color").should eql("Alternative,Goal,Participants,Completed,Conversion Rate,Z Score,Control,Winner\nblue,,5,0,0.0,N/A,true,false\nblue,control,5,2,0.4,N/A,true,false\nblue,goal,5,1,0.2,N/A,true,false\nred,,6,0,0.0,Needs 30+ participants.,false,false\nred,control,6,2,0.3333333333333333,Needs 30+ participants.,false,false\nred,goal,6,2,0.3333333333333333,Needs 30+ participants.,false,false\ngreen,,0,0,0,Needs 30+ participants.,false,false\ngreen,control,0,0,0,Needs 30+ participants.,false,false\ngreen,goal,0,0,0,Needs 30+ participants.,false,false\n")
  end
end
