function E = fita(intitialparameter,xm,ym, med)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
gs = med + intitialparameter(1)*sin(intitialparameter(2)*xm+ intitialparameter(3));
%gs = intitialparameter(1)*sin(intitialparameter(2)*xm + intitialparameter(3));
E = sum(abs(gs - ym).^2);
ya = med + intitialparameter(1)*sin(intitialparameter(2)*xm + intitialparameter(3));
%ya = intitialparameter(1)*sin(intitialparameter(2)*xm + intitialparameter(3));
clf; 

plot(xm,ym,'o', 'MarkerSize', 6);
hold on; 
plot(xm,ya,"r",'LineWidth', 3);
axis([0 24 0 max(ym)+5])
xlabel('Time(hr)');
ylabel('Temperature(C)');
drawnow; 
end
