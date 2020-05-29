function  [b_n,x,y,turn,ratio] = behavioral_decision_v2(xPos1,yPos1,xPos2,yPos2,gx,gy,orientation,Stim_angle,B,mFreq,vFreq)

%%%Find major_eff and minor_eff at time t-1
[x1,y1,m_or_v1] = SR_data(xPos1,yPos1,gx,gy,orientation,Stim_angle,mFreq,vFreq);
%%Find major_eff and minor_eff at time t
[x2,y2,m_or_v2] = SR_data(xPos2,yPos2,gx,gy,orientation,Stim_angle,mFreq,vFreq);


%%%Inihbiting factor occurs during behavioral response, leech decides to
%%%move less when presented with smaller mechanical frequencies, thus
%%%lowering its chances of finding the target location

%%%Check if mechanical response if greater than the visual response
if m_or_v2 == 1
    if mFreq < 4
        x = x2-x1;
        y = y2-y1;
        S1 = 1; S2 = 1.7; V1 = 17*pi/20; V2 = 6*pi/10;
    else
    %{
      If mechanical response is larger, use difference in eff
      spike rates between position t and t-1
    %}
    x = x2-x1;
    y = y2-y1;
    S1 = 1; S2 = 1.9; V1 = 3*pi/4; V2 = pi/4;
    end
else
    %Otherwise use current eff spike rate for visual response   
    x = x2;
    y = y2;
    
    if vFreq < 1.5
        S1 = 1; S2 = 1.9; V1 = 17*pi/20; V2 = 6*pi/10;
    else
        S1 = 1; S2 = 1.7; V1 = 17*pi/20; V2 = 6*pi/10;
    end
end


%diff = @(s) 1.8*s - 1.7;  %Scale range: [.1-1.5]
%s_factor = @(s) .9*s - .8;   %Scale range: [.1-2]

%%%Variance calculation based on effective spike rate ratio
%%%A linear relationship was used between ratio and variance
m = (V2-V1)/(S2-S1);
c = V2 - m*S2;

variance = @(s) m*s + c;

%%%Check if change in effective spike rates increases or decreases
curr_change = (x+y)/2;
pre_change = (B(2)+B(3))/2;

%If change decreases, change turn direction
if curr_change-pre_change > 0
    if B(1) == 2
        b_n = 0;
    else
        b_n = 2;
    end

%If change increases, keep turn direction the same
elseif curr_change-pre_change < 0
    b_n = B(1);
else
    b_n = 1;
end

%Ratio to to variance calculation
if abs(x) > abs(y)
    scale = variance(x/y);
    ratio = x/y;
else
    scale = variance(y/x);
    ratio = y/x;
end

%Add variance to stimulus angle
A = Stim_angle;
a = A-scale;
b = A+scale;

Turn = (b-a)*rand()+a;

if b_n == 2
    turn = -Turn;
elseif b_n == 0
    turn = Turn;
else
    turn = B(4);
end

%{    

if x > y
    scale = x/y;
else
    scale = y/x;
end

range = x/2;
if x > 0 
   r = rand();
   a = rand();
   angle = a*pi/2;
   if r > .5
       bx = 1*angle;
   else
       bx = -1*angle;
   end
else 
   r = rand();
   a = rand();
   angle = a*2*pi;
   if r > .5
       bx = 1*angle;
   else
       bx = -1*angle;
   end
end
if y > 0
   r = rand();
   a = rand();
   angle = a*pi/2;
   if r > .5
       by = 1*angle;
   else
       by = -1*angle;
   end
else
   r = rand();
   a = rand();
   angle = a*2*pi;
   if r > .5
       by = 1*angle;
   else
       by = -1*angle;
   end
end
%}



end
    
