trials = 100;

for t = 1:3
%%% Sample input frequecies
freq_Harley = [2,4,8,12,20,24];  %%%Frequencies from Harley, 2011
vfreq_Harley = [1,2,4,8,12,20,24];
mFreq_Leh = [1,1.5,2,3,4,6,8,10,12,14]; %Mechanical frequencies from Lehmkuhl, 2018
vFreq_Leh = [0.5,1,2,4,8,16]; %Visual frequencies from Lehmkuhl, 2018

input = freq_Harley;

if t == 1
    color = 'b';
    type = 'Mechanical';
    N = length(input);
    m = input;
    v = zeros(1,N);
    
elseif t == 2
    color = 'r';
    type = 'Visual';
    N = length(vfreq_Harley);
    m = zeros(1,N);
    v = vfreq_Harley;
else
    color = 'k';
    type = 'Multimodal';
    N = length(input);
    m = input;
    v = input;
end
    

%%%Allocate space for data analysis
success = zeros(N,trials);  %0 = miss, 1 = find
step_data = zeros(N,trials);
dist_data = zeros(N,trials);
for i = 1:N
    count = 0;
    for j = 1:trials
        %{
            Call navigational environnmet functions with input frequencies
              -First input is for mechanical stimuli
              -second input for visual stimuli
        %}
        [data,actual_dist,best_dist] = navigational_env_NoGraphTest_v2(m(1,i),v(1,i));
        
        dist_data(i,j) = actual_dist/best_dist;
        steps = 0;
        for k = 1:length(data)
            if data(k,:) == [2,2,2,2,2]
                %Check if data has the success indicator which is [2,2,2,2,2]
                success(i,j) = 1;
                step_data(i,j) = steps;
                break;
            else
                steps = steps+1;
            end
        end
        step_data(i,j) = steps;
    end
end
success
step_data
dist_data
%%% Calculate standard deviation and error bars
err = zeros(N,3);
for i = 1:N
    err(i,1) = std(success(i,:))/sqrt(trials);
    err(i,2) = std(step_data(i,:))/sqrt(trials);
    err(i,3) = std(dist_data(i,:))/sqrt(trials);
end


results = zeros(N,3);
%Find mean find rates, move steps, and path length multiples for each
%frequency
for i = 1:N
    count = 0;
    total_steps = 0;
    total_dist = 0;
    for j = 1:trials
        if success(i,j) == 1
            count = count+1;
        end 
        total_steps = total_steps + step_data(i,j);
        total_dist = total_dist + dist_data(i,j);
    end
    results(i,1) = count/trials;
    results(i,2) = total_steps/trials;
    results(i,3) = total_dist/trials;
    
end

results
if t == 1
figure(1+((t-1)*3))
errorbar([m],results(:,1),err(:,1),'-bs','MarkerSize',10,'MarkerEdgeColor',color,'MarkerFaceColor',color)
title([num2str(type),' stimuli find rate (n = ',num2str(trials),')'])
xlabel('Wave frequency (Hz)')
ylabel('Average find rate')
%{
figure(2+((t-1)*3))
errorbar([m],results(:,2),err(:,2),'-bs','MarkerSize',10,'MarkerEdgeColor',color,'MarkerFaceColor',color)
title([num2str(type),' stimuli moves Steps (n = ',num2str(trials),')'])
xlabel('Wave frequency (Hz)')
ylabel('Average number of moves')

figure(3+((t-1)*3))
errorbar([m],results(:,3),err(:,3),'-bs','MarkerSize',10,'MarkerEdgeColor',color,'MarkerFaceColor',color)
title([num2str(type),' stimuli path length multiple (n = ',num2str(trials),')'])
xlabel('Wave frequency (Hz)')
ylabel('Average path length multple')
%}
elseif t == 2
figure(1+((t-1)*3))
errorbar([v],results(:,1),err(:,1),'-rs','MarkerSize',10,'MarkerEdgeColor',color,'MarkerFaceColor',color)
title([num2str(type),' stimuli find rate (n = ',num2str(trials),')'])
xlabel('Wave frequency (Hz)')
ylabel('Average find rate')
%{
figure(2+((t-1)*3))
errorbar([m],results(:,2),err(:,2),'-rs','MarkerSize',10,'MarkerEdgeColor',color,'MarkerFaceColor',color)
title([num2str(type),' stimuli moves Steps (n = ',num2str(trials),')'])
xlabel('Wave frequency (Hz)')
ylabel('Average number of moves')

figure(3+((t-1)*3))
errorbar([m],results(:,3),err(:,3),'-rs','MarkerSize',10,'MarkerEdgeColor',color,'MarkerFaceColor',color)
title([num2str(type),' stimuli path length multiple (n = ',num2str(trials),')'])
xlabel('Wave frequency (Hz)')
ylabel('Average path length multple')  
%}
else
figure(1+((t-1)*3))
errorbar([m],results(:,1),err(:,1),'-ks','MarkerSize',10,'MarkerEdgeColor',color,'MarkerFaceColor',color)
title([num2str(type),' stimuli find rate (n = ',num2str(trials),')'])
xlabel('Wave frequency (Hz)')
ylabel('Average find rate')
%{
figure(2+((t-1)*3))
errorbar([m],results(:,2),err(:,2),'-ks','MarkerSize',10,'MarkerEdgeColor',color,'MarkerFaceColor',color)
title([num2str(type),' stimuli moves Steps (n = ',num2str(trials),')'])
xlabel('Wave frequency (Hz)')
ylabel('Average number of moves')

figure(3+((t-1)*3))
errorbar([m],results(:,3),err(:,3),'-ks','MarkerSize',10,'MarkerEdgeColor',color,'MarkerFaceColor',color)
title([num2str(type),' stimuli path length multiple (n = ',num2str(trials),')'])
xlabel('Wave frequency (Hz)')
ylabel('Average path length multple')
%}
end
end

        