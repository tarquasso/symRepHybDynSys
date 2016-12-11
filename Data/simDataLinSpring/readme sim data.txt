Unprocessed Simulation Data is in:
"set1/syntheticPaddleData.mat"

it contains these to variables:
- time vector t Dim: 1xN
- data vector x Cim: 7xN

Running "parsingSimDatProject.m" generates out of this unprocessed data a preprocessed file:

"set1/syntheticPaddleData_preprocessed.mat"
that contain:

General Parmeters:
angleDeg - angled in degree of the sliding table
mdisc - mass of puck
spread -  spread of the rubber band
zTouch - z value when puck first touches the rubber band

Capture Parameters:
The following are all cells, containing for each phase a vector:
timeStepsNC
thetaNC
thetadNC
thetaddNC
xNC
xdNC
xddNC
zNC
zdNC
zddNC
timeStepsIC
thetaIC
thetadIC
thetaddIC
xIC
xdIC
xddIC
zIC
zdIC
zddIC

Note:
'NC' stands for no contact
'IC' stands for in contact
