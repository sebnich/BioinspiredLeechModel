function [MechA, MechB] = mech_MinMax(s,I)

%Call mechanical spike rate algorthm to find total arbitrary spike rate

s = mech_SR_alg(s)*200;

Amax = 70;
Amin = 50;

rmax = max(mech_SR_alg([1,14]))*200;
rmin = min(mech_SR_alg([1,14]))*200;

%%% Linear Scaling factor for intensity of Stimuli
scalingInt = @(x) 0.04*x;

%%% Linear Scaling Factor for frequency
maxScale = [rmax 1.5];
minScale = [rmin .1];
m = (maxScale(2) - minScale(2)) / (maxScale(1) - minScale(1));
b = maxScale(2) - m*maxScale(1);
Scalar = @(s) (m*s + b);

%{
figure(5)
plot(linspace(rmin,rmax),Scalar(linspace(rmin,rmax)));
%}

%%%

%Maximum sigmoid function for mechanical stimuli
a = .4;
stim = linspace(rmin,rmax,24);

K = (1+exp(-a*rmax))*(1+exp(-a*rmin))*(Amax-Amin) / exp(-a*rmin)- exp(-a*rmax);

b = Amax - K / 1+exp(-a*rmax);

A = @(K,a,stim,b) (K ./ (1 + exp(-a*stim))) + b;

MechA = A(K,a,s,b) * Scalar(s) * scalingInt(I);

%{
figure(3)
plot(stim, A(K,a,stim,b));
hold on
%}

%Minimum sigmoid function for mechanical stimuli
Bmax = 30;
Bmin = 50;

K = (1+exp(-a*rmax))*(1+exp(-a*rmin))*(Bmax-Bmin) / exp(-a*rmin)- exp(-a*rmax);
b = Bmax - K / 1+exp(-a*rmax);

B = @(K,a,stim,b) (K ./ (1 + exp(-a*stim))) + b;

MechB = B(K,a,s,b) * Scalar(s) * scalingInt(I);

%{
plot(stim,B(K,a,stim,b));

title('Mechanical Minimum and Maximum Spike Rates (14Hz, 100um)')
xlabel('Neural reponse (arbitrary)')
ylabel('Minimum and Maximum spike rates (arbitrary)')
legend('Major spike rate response','Minor spike rate response')
%}

end
