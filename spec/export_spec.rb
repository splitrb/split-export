require 'spec_helper'

describe Split::Export do
  before :each do
    experiment = Split::ExperimentCatalog.find_or_create({'link_color': ["control", "goal"]}, 'blue', 'red', 'green')
    blue = Split::Alternative.new('blue', 'link_color')
    blue.participant_count = 50
    blue.set_completed_count(20, "control")
    blue.set_completed_count(10, "goal")
    blue.save
    red = Split::Alternative.new('red', 'link_color')
    red.participant_count = 60
    red.set_completed_count(10, "control")
    red.set_completed_count(30, "goal")
    red.save
  end

  it "should generate a csv of split data" do
    Split::Export.to_csv.should eql("Experiment,Alternative,Participants,Completed,Conversion Rate,Z score,Control,Winner\nlink_color,blue,50,30,0.6,0.0,true,false\nlink_color,red,60,40,0.667,0.724,false,false\nlink_color,green,0,0,0.0,0.0,false,false\n")
  end

  it "should generate a detailed csv of split data for a single table" do
    Split::Export.experiment_to_csv("link_color").should eql("Alternative,Goal,Participants,Completed,Conversion Rate,Z Score,Control,Winner\nblue,,50,0,0.0,0.0,true,false\nblue,control,50,20,0.4,0.0,true,false\nblue,goal,50,10,0.2,0.0,true,false\nred,,60,0,0.0,0.0,false,false\nred,control,60,10,0.167,-2.736,false,false\nred,goal,60,30,0.5,3.257,false,false\ngreen,,0,0,0.0,0.0,false,false\ngreen,control,0,0,0.0,0.0,false,false\ngreen,goal,0,0,0.0,0.0,false,false\n")
  end
end
