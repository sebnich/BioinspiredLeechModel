function Si = ellipse(Sm,Sv,orientation,stim_angle,I,graph)

phi = orientation-stim_angle;
N = 100;

%%% Mechanical Stimulus
if Sm == 0
    Smech = zeros(1,N);
else
    %Call min and max spike rate function
    [Amech,Bmech] = mech_MinMax(Sm,I);
    theta = linspace(0,2*pi, N);
    Smech = nan(1,N);
    k = 1;

    while k < N+1
        %Compute ellipse using min and max spike rates
        Smech(1,k) = (Amech*Bmech) / ((Amech^2)*cos(theta(1,k)-phi).^2 + (Bmech^2) * sin(theta(1,k)-phi).^2).^(1/2);
        k = k+1;
    end
end

%%%Visual stimuli
if Sv == 0
    Svis = zeros(1,N);
else
    [Avis,Bvis] = vis_MinMax(Sv);
    theta = linspace(0,2*pi, N);
    Svis = nan(1,N);
    k = 1;
    while k < N+1

        Svis(1,k) = (Avis*Bvis) / ((Avis^2)*cos(theta(1,k)-phi).^2 + (Bvis^2) * sin(theta(1,k)-phi).^2).^(1/2);
        k = k+1;
    end
end

Si = abs(Smech - Svis);

if graph == 1
    
    figure(1)
    
    polarplot(theta, Smech,'r',theta, Svis,'b', theta, Si, 'black','linewidth',4);
    pol = gca;
    pol.FontSize = 13;
    lgd = legend("Mechanical Reponse", "Visual Reponse","Integrated Reponse");
    set(lgd,'FontSize',14);
    
    hold on

end

end
