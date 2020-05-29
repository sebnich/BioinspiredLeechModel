function [data,actual_dist,best_dist] = navigational_env_NoGraphTest_v2(mFreq,vFreq)

x_range = [0 83];
y_range = [0 83];

%%% Behavioral area boundaries
area_radius = 41.5;

%%% Goal area

goal_radius = 7;
goal_angle = pi/4;
xG = (area_radius-goal_radius)*cos(goal_angle)+area_radius;
yG = (area_radius-goal_radius)*sin(goal_angle)+area_radius;
g = [xG yG goal_radius]; %x,y,r for goal
gR = 7; %radius for goal

%%% Starting position for the agent

aR = 1.1; %Average length of a leech
xR = (area_radius-aR)*cos(5*pi/4)+area_radius;
yR = (area_radius-aR)*sin(5*pi/4)+area_radius;
start = [10 10 pi/2]; %x,y,r for start

best_dist = (((g(1)-start(1))^2)+(g(2)-start(2))^2)^(1/2);
dist = 0;

v = 1; %velocity
    function x_dir = x(theta,v)
        x_dir = v*cos(theta);
    end
    function y_dir = y(theta,v)
        y_dir = v*sin(theta);
    end

%Agents initial position
T = 500; %time steps
N = 2;  %number of steps in between measurments

aPos = zeros(T,3); %An array to store the agents positions
aPos(1,:) = [start(1) start(2) 0]; %x, y, theta - initial conditions

%Agents initial orientation
a = [x(aPos(1,3),v) y(aPos(1,3),v) 0]; %finding a vector using agent's position
b = [g(1)-aPos(1,1) g(2)-aPos(1,2) 0]; %b vector using agent's position and goal position

behavior = zeros(ceil(T/N),5);
behavior(1,:) = ones(1,5);
b_t = 2;
t = 2;

flag = 0;
count = 0;
while t < T  
    for i = 1:N
        %move
        aPos(t,:) = [aPos(t-1,1)+a(1) aPos(t-1,2)+a(2) aPos(t-1,3)];
        %Check if agent is at area boundary
        dist = dist + ((((aPos(t,1)-aPos(t-1,1))^2)+(aPos(t,2)-aPos(t-1,2))^2))^(1/2);
        
        if (((aPos(t,1)-area_radius)^2)+((aPos(t,2)-area_radius)^2))^(1/2) >= area_radius
            diff = (area_radius-aR) - (((((aPos(t-1,1)-area_radius)^2)+((aPos(t-1,2)-area_radius)^2))^(1/2)));
            aPos(t,:) = [aPos(t-1,1)+x(aPos(t-1,3),diff) aPos(t-1,2)+x(aPos(t-1,3),diff) aPos(t-1,3)];
        end
        t=t+1;
        flag = 0;
        if (((aPos(t-1,1)-g(1))^2)+((aPos(t-1,2)-g(2))^2))^(1/2) < aR + gR %check if agent has reached goal
            %{
            behavior(b_t,:) = [2,2,2,2,2];
            pause(1);
            %}
            count = count+1; 
            if count == 30              
                flag = 1;
            end
        else
            count = 0;
        end        
    end
    if flag == 1
        behavior(b_t,:) = [2,2,2,2,2];
        break
    end
    %take measurement and calculate turn angle
    num = dot(a,b);  
    dem = norm(a)*norm(b);
    theta = acosd(num/dem);  %Find angle between agent and goal
    q = cross(a,b);
    e = theta*(pi/180);  %Convert angle to radians, multiple by sign of a cross b

    [b1,b2,b3,b4,b5] = behavioral_decision_v2(aPos(t-1-N,1),aPos(t-1-N,2),aPos(t-1,1),aPos(t-1,2),g(1),g(2),aPos(t-1,3),e,behavior(b_t-1,:),mFreq,vFreq);
    behavior(b_t,:) = [b1,b2,b3,b4,b5];

    update = aPos(t-1,3) + behavior(b_t,4);
    a = [x(update,v) y(update,v) 0]; %Update agent orientation vector
    b = [g(1)-aPos(t-1,1) g(2)-aPos(t-1,2) 0];  %Update vector from agent to goal
    aPos(t-1,3) = update; %Update agent orientation towards proportional control output
    b_t = b_t+1;
end
actual_dist = dist;
data = zeros(size(behavior));
data = behavior;
%char = "Turn      dy       dx        Angle        Ratio"
%{
char = "             dy       dx        Angle        Proportion"
behavior
b = [];


for i = 1:length(behavior(:,5))-1
    if behavior(i+1,5) ~= 0
        b(1,i) = behavior(i+1,5);
    end
    
end
length(b)
length(linspace(1,length(b)-1,length(b)))
hist(b)
figure(4)
plot(linspace(1,length(b),length(b)),b)
%}
%}
end

