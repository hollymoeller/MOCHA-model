function [Lset,alphaset,biol] = MOCHAchemostat(tset,ic,D,L0,I0,B0,r,yGM,uCL,uNI,uCB,uNB,qC,qN,qG,attack,kappa0,kappaI,kappaB,kappaP,kappaV,kappaM)

options = odeset('RelTol',1e-6,'AbsTol',1e-5);

[~,biol] = ode23s(@ecosysmodel_T,tset,ic);%,options);
%[~,biol] = ode15s(@ecosysmodel_T,tset,ic,options);


Lset = L0.*exp(-kappa0-kappaV.*biol(:,1)-kappaP.*biol(:,2)-kappaM.*biol(:,3)-kappaB.*biol(:,4)-kappaI.*biol(:,5));
alphaset = NaN(length(tset),4);
for i = 1:length(tset)
   alphaset(i,:) = mixo_opt(Lset(i),biol(i,5),biol(i,4)); 
end

    function system = ecosysmodel_T(~,x)
        V = x(1);   % digestive vacuoles
        P = x(2);   % photosynthetic plastids
        M = x(3);   % growth machinery
        B = x(4);   % bacteria
        I = x(5);   % inorganic nutrients
        
        L = L0*exp(-kappa0 - kappaV*V - kappaB*B - kappaM*M - kappaI*I - kappaP*P);
        jC = uCL*L*P + uCB*B*V - r*(P+V+M);
        jN = uNI*I*P + uNB*B*V;
        jG = yGM*M;
        
        growth = min([qC*jC,qN*jN,qG*jG]);
        
        alphas = mixo_opt(L,I,B);
        
        dVdt = growth*alphas(1) - D*V;
        dPdt = growth*alphas(2) - D*P;
        dMdt = growth*alphas(3) - D*M;
        dBdt = D*(B0-B) - attack*V*B;
        dIdt = D*(I0-I) - uNI*I*P;
        
        system = [dVdt; dPdt; dMdt; dBdt; dIdt];
    end


    function z = mixo_opt(Li,Ii,Bi)
        strats = NaN(3,4);
        
        % Strict phagotrophy
        alpha_til_V = max([(qG*yGM+qC*r)/(qC*uCB*Bi + qG*yGM),(qG*yGM)/(qN*uNB*Bi+qG*yGM)]);
        alpha_til_P = 0;
        alpha_til_M = 1 - alpha_til_V - alpha_til_P;
        g_til = qG*yGM*alpha_til_M; %growth rate of strict phagotroph
        strats(1,1) = alpha_til_V;
        strats(1,2) = alpha_til_P;
        strats(1,3) = alpha_til_M;
        strats(1,4) = g_til;
        
        % Strict phototrophy
        alpha_bar_V = 0;
        alpha_bar_P = max([(qG*yGM+qC*r)/(qC*uCL*Li+qG*yGM),qG*yGM/(qN*uNI*Ii+qG*yGM)]);
        alpha_bar_M = 1-alpha_bar_P;
        g_bar = qG*yGM*alpha_bar_M; % growth rate of strict phototroph
        strats(2,1) = alpha_bar_V;
        strats(2,2) = alpha_bar_P;
        strats(2,3) = alpha_bar_M;
        strats(2,4) = g_bar;

        % Mixotrophy
        term.a = (qN*uNB*Bi-uCB*qC*Bi)/(qC*uCL*Li-qN*uNI*Ii);
        term.b = (qG*yGM+uCB*qC*Bi)/(qG*yGM+qC*uCL*Li);
        term.c = (qG*yGM+qC*r)/(qG*yGM+qC*uCL*Li);
        term.d = (qC*r)/(qC*uCL*Li-qN*uNI*Ii);
        alpha_star_V = (term.c-term.d)/(term.a+term.b); 
        alpha_star_P = (qG*yGM*(1-alpha_star_V)+qC*r-qC*uCB*Bi*alpha_star_V)/(qG*yGM+qC*uCL*Li);
        alpha_star_M = 1 - alpha_star_V - alpha_star_P;
        g_star = qG*yGM*alpha_star_M;
        strats(3,1) = alpha_star_V;
        strats(3,2) = alpha_star_P;
        strats(3,3) = alpha_star_M;
        strats(3,4) = g_star;

        % Picking optimum
        strats_simplify = strats(strats(:,1)>=0,:);
        strats_simplify = strats_simplify(strats_simplify(:,2)>=0,:);
        %strats_simplify = strats(strats(:,2)>=0&strats[,1]>=0,];
        z = strats_simplify(strats_simplify(:,4)==max(strats_simplify(:,4)),:);

    end



end