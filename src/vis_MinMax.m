function [VisA, VisB] = vis_MinMax(s)

%Call mechanical spike rate algorthm to find total arbitrary spike rate
s = vis_SR_alg(s)*50;

Amax = 70;
Amin = 50;

rmax = max(vis_SR_alg([1,14]))*50;
rmin = min(vis_SR_alg([1,14]))*50;

%%% Linear Scaling Factor for frequency
maxScale = [rmax 1];
minScale = [rmin .3];
m = (maxScale(2) - minScale(2)) / (maxScale(1) - minScale(1));
b = maxScale(2) - m*maxScale(1);
Scalar = @(s) (m*s + b);

%{
figure(5)
plot(linspace(rmin,rmax),Scalar(linspace(rmin,rmax)));
%}

%%%

%Find maximum sigmoid function based on maximun and minimum arbitrary spike rates
a = .4;
stim = linspace(rmin,rmax,24);

K = (1+exp(-a*rmax))*(1+exp(-a*rmin))*(Amax-Amin) / exp(-a*rmin)- exp(-a*rmax);

b = Amax - K / 1+exp(-a*rmax);

A = @(K,a,stim,b) (K ./ (1 + exp(-a*stim))) + b;

VisA = A(K,a,s,b) * Scalar(s);

%{
figure(3)
plot(stim, A(K,a,stim,b));
hold on
%}

%Find minimum sigmoid function
Bmax = 30;
Bmin = 50;

K = (1+exp(-a*rmax))*(1+exp(-a*rmin))*(Bmax-Bmin) / exp(-a*rmin)- exp(-a*rmax);
b = Bmax - K / 1+exp(-a*rmax);

B = @(K,a,stim,b) (K ./ (1 + exp(-a*stim))) + b;

VisB = B(K,a,s,b) * Scalar(s);

%{
plot(stim,B(K,a,stim,b));S
title('Visual Minimum and Maximum Spike Rates (1Hz)')
xlabel('Neural reponse (arbitrary)')
ylabel('Minimum and Maximum spike rates (arbitrary)')
legend('Major spike rate response','Minor spike rate response')
%}

end
