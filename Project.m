clc 
clear all 
close all
warning off


% This is to display which Model you want use (which case you want to know)
options = {'Constant_Temperature_in_Shop','Constant_Temperature_Out_Shop', 'Fluctuating_Temperature', 'Constant_Temperature_in_Home','Critical_Time_at_Constant_Temperature_Model','Exist'};
% Display dialogue box with options
[selectedOption, ~] = listdlg('PromptString', 'Select an option:', ...
                               'SelectionMode', 'single', ...
                               'ListString', options,...
                               'ListSize', [300, 200]);
Opt = options{selectedOption};
Opt;



% Define the unknown function (variable is t here)
syms T(t);
k_values = [1,2,3,4,5];



switch Opt
    %%
    case 'Constant_Temperature_in_Shop'
        TSol = {}
        Tamb = str2double(inputdlg("Enter the Ambient Temperature of the store"))
        % The ODE to be solved
        for i = 1:length(k_values)
        %K = str2double(inputdlg("Enter the value of K"))
        ode = diff(T,t) + k_values(i)*(T - Tamb) == 0;
        % Initial conditions for the ODE
        cond1 = T(0) == 4;
        TSol{i} = dsolve(ode,cond1);
        end
      %%
      
    case 'Constant_Temperature_Out_Shop'
        Tiniti = [8, 10, 12, 14, 16, 18]
        TSol = {} 
        Tamb = str2double(inputdlg("Enter the Ambient Temperature of the Car"))
        % The ODE to be solved
        for i = 1:length(Tiniti)
            for j = 1:length(k_values)
                %K = str2double(inputdlg("Enter the value of K"))
                ode = diff(T,t) + k_values(j)*(T - Tamb) == 0;
                % Initial conditions for the ODE
                cond1 = T(0) == Tiniti(i);
                TSol{j,i} = dsolve(ode,cond1)           
            end
        end
       %%
    case 'Fluctuating_Temperature' 
        
        optionss = {'Michigan', 'Texas'};
        % Display dialogue box with options
        [selectedOption, ~] = listdlg('PromptString', 'Select an option:', ...
                               'SelectionMode', 'single', ...
                               'ListString', optionss,...
                               'ListSize', [300, 200]);
        Opts = optionss{selectedOption};
        
        % Reading the data
        data = xlsread("C:\Users\altwa1qm\Desktop\Temp.xlsx", "O_Data") 
        x = data(:,1);
     
        
        if strcmp(Opts,'Michigan')
        y = data(:,5);
        elseif strcmp(Opts,'Texas')
        y = data(:,6);
        else 
            return
        end 
        
        med = (min(y) + max(y))/2
        scatter(x,y); 
        amplitude = med - min(y); 
        freq = 2*pi/24;    % use freq value of 15 for Michigan data
        phase = pi; % use freq value of pi/3 for Michigan data
        intitialparameter = [amplitude, freq, phase]; 
        mx = @(intitialparameter)fita(intitialparameter,x,y,med); 
        outputparameters = fminsearch(mx,intitialparameter);
        disp(outputparameters)
        % Example vector
        vec = [outputparameters(1), outputparameters(2), outputparameters(3)];
        text = {'Amplitude:', 'Frequency:', 'Phase:'};
        for i = 1:numel(vec)
       fprintf('%s %d\n', text{i}, vec(i));
        end 
        latex_expression = [num2str(roundn(med,-3)),'+',num2str(roundn(outputparameters(1),-3)),'*','sin(', num2str(roundn(outputparameters(2),-3)),'t', '+ ', num2str(roundn(outputparameters(3),-3)), ')'];
        annotation('textbox', [0.35, 0.2, 0.1, 0.1], 'String', latex_expression, 'Interpreter', 'latex', 'FontSize', 12);
        
        % Checking if the fitting is good or not
        fitting = {'The fitting is good', 'The fitting is bad'};
        % Display dialogue box with options
        [selectedOption, ~] = listdlg('PromptString', 'Select an option:', ...
                               'SelectionMode', 'single', ...
                               'ListString', fitting,...
                               'ListSize', [300, 200]);
        fits = fitting{selectedOption};
        disp(fits)
        if strcmp(fits, 'The fitting is bad')
            return 
        else 
            Tiniti = [8, 10, 12, 14, 16, 18]
            TSol = {} 
            % The ODE to be solved
             for i = 1:length(Tiniti)
                 for j = 1:length(k_values)
                     %K = str2double(inputdlg("Enter the value of K"))
                      ode = diff(T,t) + k_values(j)*(T - (med + outputparameters(1)*sin(outputparameters(2)*t + outputparameters(3)))) == 0;
                      % Initial conditions for the ODE
                      cond1 = T(12) == Tiniti(i);
                      TSol{j,i} = dsolve(ode,cond1) ;          
                 end
              end
        end
       %% 
           
                      
                       

    case 'Constant_Temperature_in_Home'
        Tiniti = [16, 18]
        TSol = {} 
        Tamb = str2double(inputdlg("Enter the temperature of home's refrigerator"))
        % The ODE to be solved
        for i = 1:length(Tiniti)
            for j = 1:length(k_values)
                %K = str2double(inputdlg("Enter the value of K"))
                ode = diff(T,t) + k_values(j)*(T - Tamb) == 0;
                % Initial conditions for the ODE
                cond1 = T(0) == Tiniti(i);
                TSol{j,i} = dsolve(ode,cond1)           
            end
        end
        
     case 'Critical_Time_at_Constant_Temperature_Model'
        TSol = {}
        solutions = {}
        Tamb = str2double(inputdlg("Enter the Ambient Temperature of the customer counter"))
        Tiniti = str2double(inputdlg("Enter the intital temperature of home's refrigerator"))
        T_targ = str2double(inputdlg("Enter the critical temperature"))
        for j = 1:length(k_values)
                %K = str2double(inputdlg("Enter the value of K"))
                ode = diff(T,t) + k_values(j)*(T - Tamb) == 0;
                % Initial conditions for the ODE
                cond1 = T(0) == Tiniti;
                TSol{j} = dsolve(ode,cond1)
                solutions{j} =  double(solve(TSol{j}==T_targ, t))
             
        end
        t_values = cellfun(@(sol) sol(1), solutions);
        plot(k_values, t_values, 'o', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
        hold on;
        % Connect the points with a line
        plot(k_values, t_values, 'r-', 'LineWidth', 1);
        % Customize the plot
        xlabel('k($hr^{-1}$)', 'Interpreter', 'latex');
        ylabel('Time($hr$)', 'Interpreter', 'latex');
        xticks([1,2,3,4,5])
        %xlabel('$K^{-1}$', 'Interpreter', 'latex')
          
    case 'Exist' 
        return;
                    
end 



% The next part of the code is for plotting. 


switch Opt
    case 'Constant_Temperature_in_Shop'
for j = 1 :length(k_values)
    x = vpa(simplify(TSol{j}),3);
    % You can also (sometimes) write the equation in a "pretty" format
    pretty(x)
    fplot(x)
    xlim([0 24])
    hold on
end 
    legend_labels = {'K = 1', 'K = 2', 'K = 3', 'K = 4', 'K = 5'};
    legend(legend_labels,'Location', 'best');
    xlabel('Time(hr)');
    ylabel('Temperature(C)');

   case {'Constant_Temperature_Out_Shop', 'Fluctuating_Temperature',}
    for i = 1:length(Tiniti) 
            subplot(length(Tiniti)/2, 2, i);
            for j = 1:length(k_values) 
                x = vpa(simplify(TSol{j,i}),3);
                % You can also (sometimes) write the equation in a "pretty" format
                pretty(x);
                 
                 fplot(x);
                 xlim([0 10]);
                 ylim([0 20]);
                 hold on;
             
            end
            legend_labels = {'K = 1', 'K = 2', 'K = 3', 'K = 4', 'K = 5'};
            legend(legend_labels,'Location', 'best');
            xlabel('Time(hr)');
            ylabel('Temperature(C)');  
            title(['T = ',num2str(Tiniti(i)),' C ']);
   
    end 
    case {'Constant_Temperature_in_Home'}
    for i = 1:length(Tiniti) 
            subplot(2, length(Tiniti)/2, i);
            for j = 1:length(k_values) 
                x = vpa(simplify(TSol{j,i}),3);
                % You can also (sometimes) write the equation in a "pretty" format
                pretty(x);
                 
                 fplot(x);
                 xlim([0 5]);
                 ylim([0 20]);
                 hold on;
             
            end
            legend_labels = {'K = 1', 'K = 2', 'K = 3', 'K = 4', 'K = 5'};
            legend(legend_labels,'Location', 'best');
            xlabel('Time(hr)');
            ylabel('Temperature(C)');  
            title(['T = ',num2str(Tiniti(i)),' C ']);
   
   end 
   
   

end



