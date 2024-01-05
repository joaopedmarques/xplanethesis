%% X-Plane Connect MATLAB Example Script
% This script demonstrates how to read and write data to the XPC plugin.
% Before running this script, ensure that the XPC plugin is installed and
% X-Plane is running.
%% Import XPC
clear all
addpath('../')
import XPlaneConnect.*

%% Define Data Refs
airspeedDREF = 'sim/flightmodel/position/indicated_airspeed';
remainingfuelDREF = 'sim/flightmodel/weight/m_fuel_total';
gearDREF = 'sim/cockpit/switches/gear_handle_status';
adfDREF = 'sim/cockpit/radios/adf1_dir_degt';

%Socket = openUDP('192.168.1.238',49009,0,5000);
Socket = openUDP();%uses default values

%% Colocar o avião numa localização especifica (crashes the sim)
%%sendPOSI([37.524, -122.06899, 2500, 0, 0, 0, 1], 0);

sendTEXT('Matlab code is running.',10, 10); % display text in sim bottom left corner
sendDREF(gearDREF, 0, Socket); %raise landing gear example

while 1
    
    posi = getPOSI(0, Socket);
    ctrl = getCTRL(0, Socket);

    %%print exemplo getposi
    %fprintf('Loc: (%4.4f, %4.4f, %4.4f)\nHeading:%.2fº || Roll:%.2fº || Pitch:%.2fº\nGear:%1.0f\n', ...
    %posi(1), posi(2), posi(3), posi(6), posi(5), posi(4), posi(7));

    %%print exemplo getctrl
    %fprintf('Aileron:%2.3f Elevator:%2.3f Rudder:%2.3f\nThrottle:%2.3f Gear:%1.0f\n', ...
    %ctrl(2), ctrl(1), ctrl(3), ctrl(4), ctrl(5));
    
    %% coordinates & controls position %%
    fprintf('Loc: (%4.4f, %4.4f, %4.4f) Aileron:%2.3f Elevator:%2.3f Rudder:%2.3f Gear:%1.0f\n', ...
    posi(1), posi(2), posi(3), ctrl(2), ctrl(1), ctrl(3), ctrl(5));
   
    %% heading, roll & pitch test %% %%roll e pitch inverted for some reason...
    fprintf('Heading:%.2fº || Roll:%.2fº || Pitch:%.2fº\n', ...
    posi(6), posi(5), posi(4));
    
    %% Print DREFs values
    airspeed = getDREFs(airspeedDREF, Socket);  %% airspeed in kts, Float
    fprintf('Airspeed: %.0f Kts', airspeed);

    remainingfuel = getDREFs(remainingfuelDREF, Socket); %% Fuel in kgs, Float
    fprintf('Remaining fuel: %.3f Kgs | ', remainingfuel);

    gear = getDREFs(gearDREF, Socket); %% gear lever position, Boolean
    fprintf('Gear position: %.0f \n', gear);


    adf= getDREFs(adfDREF, Socket);
    %fprintf('adf: %f \n',adf);
    %sendDREF(adfDREF, 20, Socket);
    
    fprintf('\n');
    pause(1);%1 second delay

end
closeUDP(Socket);
