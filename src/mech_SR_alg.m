function y_out = mech_SR_alg(z)

freq = [1,1.5,2,3,4,6,8,10,12,14];
Sus_SR = [5,3.5,7,8.5,3.5,3.4,4,6,7.5,12.5]/12.5;

%figure(1)
%plot(freq,Sus_SR)

%Values will be updated in future, using these to get model up and running
save = [2.5,.4,13.6,4.7,.1];
m1 = save(1);
s1 = save(2);
m2 = save(3);
s2 = save(4);
c =  save(5);

zp = [0:1:24];

Bp1 = (c/([(2*pi*s1^2)^(1/2)]));
Ep1 = exp(-[((zp-m1).^2)./(2*s1^2)]);

Bp2 = ((1-c)/([(2*pi*s2^2)^(1/2)]));
Ep2 = exp(-[((zp-m2).^2)./(2*s2^2)]);

y = Bp1.*Ep1 + Bp2.*Ep2;

%%%%Plots out spike rate distribution curve depending on stimuli frequency
%%%%Bimodal distribution curve

%{
figure(2)
plot(zp,y)
title('Mechnical Arbitrary Neural Response')
xlabel('Frequency (Hz)')
ylabel('Neural Response (Arbitrary)')
%}

%{
save1 = [1, 1.5, .75];

i = save1(1);
k = save1(2);
j = save1(3);

l = 2;
m = 4;
n = 1;

x = [0:1:24];
y1 = lognpdf(x,i,j).*(x.*k) + lognpdf(x,l,m).*(x.*n);


%figure(3)
%plot(x,y1)

%}

Bp1 = (c/([(2*pi*s1^2)^(1/2)]));
Ep1 = exp(-[((z-m1).^2)./(2*s1^2)]);

Bp2 = ((1-c)/([(2*pi*s2^2)^(1/2)]));
Ep2 = exp(-[((z-m2).^2)./(2*s2^2)]);

y_out = Bp1.*Ep1 + Bp2.*Ep2;

end