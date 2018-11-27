l = -10:0.0001:10;
I_0 = 1e12;
N_0 = sqrt(I_0);
I_m = I_0/2;
N_m = sqrt(I_0)/2;
n_a = 1;
n_n = 1.4;
sigma = 0.05;
lambda = 0.75;
lc = 2*log(2)/pi * lambda*lambda/sigma;
r = ((n_a-n_n)/(n_a+n_n))^2;
t = 1-r;
I_s = I_0/2 * r;
N_s = sqrt(I_0)*r;
I_inc = I_0/2 * r*t*t;
I_i = 2*sqrt(I_m*I_s)*cos(2*pi/lambda*2*l).*exp(-8*pi*pi*(l.*l)/lc/lc);
I = I_m + I_s + I_inc + I_i;
N = N_m+N_s+2*sqrt(N_m*N_s)*cos(2*pi/lambda*2*l).*exp(-8*pi*pi*(l.*l)/lc/lc);
% plot(l,I)
%hold on
%plot(I_m + I_s + 2*sqrt(I_m*I_s)*cos(2*pi/lambda*2*l))

n_n = 1.4-0.00001;
r = ((n_a-n_n)/(n_a+n_n))^2;
I_s = I_0/2 * r;
I_inc = I_0/2 * r*t*t;
I_i = 2*sqrt(I_m*I_s)*cos(2*pi/lambda*2*l).*exp(-8*pi*pi*(l.*l)/lc/lc);
I2 = I_m + I_s + I_inc + I_i;
plot(l,(I-I2)/I_0)
figure
errorbar(l,(I-I2),2*N)