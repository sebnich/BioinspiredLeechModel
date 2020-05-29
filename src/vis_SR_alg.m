function y_out = vis_SR_alg(z)


Fre = [0.5 1 2 4 8 16];
SR =  [36 42 29 8 5 6];
Norm_sr = SR/126;

I = 0;
K = 1.06;
J = 0.91;

x = 0:.5:24;

y = lognpdf(x,I,K).*(x*(J));

%{
plot(x,y)
title('Visual Arbitrary Neural Response')
xlabel('Frequency (Hz)')
ylabel('Neural Response (Arbitrary)')
%}

y_out = lognpdf(z,I,K).*(z*(J));

end