clc 
clear all 
close all
warning off

syms T(t);

t_v = [12:1:24];
T_v = (19.194 .* exp(3 .* t_v) + 17.802 .* ((exp(3 .* t_v) .* sin(0.279 .* t_v + 3.245) ./ 3) - (0.279 .* exp(3 .* t_v) .* cos(0.279 .* t_v + 3.245)) ./ 9) ./ 1.008649 - 5.374629708 * 10^16) ./ exp(3 .* t_v);


%T_v = (19.194.*exp(3.*t_v)+17.802.*(exp(3.*t_v).*sin(0.279.*t_v+3.245)./3 - 0.279.*exp(3.*t_v)*cos(0.279.*t_v+3.245)./3)./1.008649-5.599279821*10^16)./exp(3.*t_v)

ode = diff(T,t) + 3*(T - (19.194 + 5.934*sin(0.279*t + 3.245))) == 0;
cond1 = T(12) == 8;
TSol = dsolve(ode,cond1)
x = vpa(simplify(TSol,3));
pretty(x);
fplot(x);
hold on 
%figure 
scatter(t_v, T_v, 'filled', 'MarkerFaceColor', 'r');
xlabel("Time (hr)")
ylabel("Temperature (C)")
legend('Matlab Solution', 'Hand Solution','Position', [0.5, 0.4, 0.1, 0.1])
xlim([12 24]);
ylim([0 29]);
