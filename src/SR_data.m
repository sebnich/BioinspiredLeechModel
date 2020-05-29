function  [x_eff,y_eff,m_or_v] = SR_data(axLoc,ayLoc,gxLoc,gyLoc,orientation,Stim_angle,mFreq,vFreq)

Mechanical_stim = mFreq;
Visual_stim = vFreq;

Goal_intensity = ((gxLoc-10)^2+(gyLoc-10)^2)^(1/2); %initial amplitude of the wave (um)
Distance_from_goal = ((gxLoc-axLoc)^2+(gyLoc-ayLoc)^2)^(1/2);

I = @(dist) -abs(dist)+Goal_intensity; %amplitude of the wave at current location
Intensity = I(Distance_from_goal);

%%%Call spike rate algorithms to find if mechanical or visual neural
%%%frequencies are larger
mech_SR = mech_SR_alg(mFreq);
vis_SR = vis_SR_alg(vFreq);
scalar = vis_SR_alg(1)/mech_SR_alg(14);
mech_SR = mech_SR/scalar;

if mech_SR < vis_SR
    m_or_v = 0;
else
    m_or_v = 1;
end

%Call elliptical function
agentDist = ellipse(Mechanical_stim, Visual_stim,orientation,Stim_angle,Intensity,0);
%Find major and minor sensors and calculate effective distributions
[ax_sensors, ay_sensors] = findXYSensors(agentDist);
ax_eff = mean(ax_sensors);
ay_eff = mean(ay_sensors);

x_eff = ax_eff;
y_eff = ay_eff;

end

%%%Split elliptical sensors into major and minor groupings
function [x, y] = findXYSensors(dist)
N = length(dist);
x_sensors = zeros(1,N/2);
y_sensors = zeros(1,N/2);
x_count = 1;
y_count = 1;

for i = 1:N    
    if (i >= 7*N/8 || (i >= 1 && i < N/8) || i >= 3*N/8 && i < 5*N/8)     
        x_sensors(x_count) = dist(1,i);
        x_count = x_count+1;
    else
        y_sensors(y_count) = dist(1,i);
        y_count = y_count+1;
    end
end
x = x_sensors;
y = y_sensors;
end