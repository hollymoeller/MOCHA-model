Pcol = [123/255,188/255,73/255];
Vcol = [168/255,68/255,151/255];
Mcol = [231/255,186/255,96/255];

%%

% Parameters
% External resource availability
L0 = 50;%1000;
I0 = 10;%10;%0; %10
B0 = .8e6;%1e6; 

% Respiratory costs
r = 1; %0.1#0.01

% Uptakes
yGM = 1;
uCL = 0.01;%0.01*2;
uNI = 1;
attack = 0.000003;
f = 1; % conversion efficiency of bacterial C to mixotroph C
uCB = attack*f;
uNB = uCB/10; %5*attack*f; %2*uCB/10;%

% Stoichiometries
qC = 1;
qN = 1;
qG = 1;

% Dilution rate of the chemostat
D = 0.2;

% Absorptivities of chemostat components
kappa0 = 0; % base absorptivity of water
kappaI = 0; % absorptivity of inorganic nutrients
kappaB = 0.; %#00001 # per capita absorptivity of bacteria
kappaP = 0.; %#001 # per capita absorptivity of plastids
kappaV = 0.; %#00001 # per capita absorptivity of vacuoles
kappaM = 0.; %#00001 # per capita absorptivity of growth machinery


% Set up initial conditions
L = L0;
I = I0; 
B = B0; 

strats = NaN(3,4);
% Strict phagotrophy
alpha_til_V = max([(qG*yGM+qC*r)/(qC*uCB*B + qG*yGM),(qG*yGM)/(qN*uNB*B+qG*yGM)]);
alpha_til_P = 0;
alpha_til_M = 1 - alpha_til_V - alpha_til_P;
g_til = qG*yGM*alpha_til_M; %growth rate of strict phagotroph
strats(1,1) = alpha_til_V;
strats(1,2) = alpha_til_P;
strats(1,3) = alpha_til_M;
strats(1,4) = g_til;

% Strict phototrophy
alpha_bar_V = 0;
alpha_bar_P = max([(qG*yGM+qC*r)/(qC*uCL*L+qG*yGM),qG*yGM/(qN*uNI*I+qG*yGM)]);
alpha_bar_M = 1-alpha_bar_P;
g_bar = qG*yGM*alpha_bar_M; % growth rate of strict phototroph
strats(2,1) = alpha_bar_V;
strats(2,2) = alpha_bar_P;
strats(2,3) = alpha_bar_M;
strats(2,4) = g_bar;

% Mixotrophy
term.a = (qN*uNB*B-uCB*qC*B)/(qC*uCL*L-qN*uNI*I);
term.b = (qG*yGM+uCB*qC*B)/(qG*yGM+qC*uCL*L);
term.c = (qG*yGM+qC*r)/(qG*yGM+qC*uCL*L);
term.d = (qC*r)/(qC*uCL*L-qN*uNI*I);
alpha_star_V = (term.c-term.d)/(term.a+term.b); 
alpha_star_P = (qG*yGM*(1-alpha_star_V)+qC*r-qC*uCB*B*alpha_star_V)/(qG*yGM+qC*uCL*L);
alpha_star_M = 1 - alpha_star_V - alpha_star_P;
g_star = qG*yGM*alpha_star_M;
strats(3,1) = alpha_star_V;
strats(3,2) = alpha_star_P;
strats(3,3) = alpha_star_M;
strats(3,4) = g_star;

strats_simplify = strats(strats(:,1)>=0,:);
strats_simplify = strats_simplify(strats_simplify(:,2)>=0,:);
alphas = strats_simplify(strats_simplify(:,4)==max(strats_simplify(:,4)),:);

ic = [alphas(1:3),B0,I0];
tset = linspace(0,100,1000);


[Lset,alphaset,biol] = MOCHAchemostat(tset,ic,D,L0,I0,B0,r,yGM,uCL,uNI,uCB,uNB,qC,qN,qG,attack,kappa0,kappaI,kappaB,kappaP,kappaV,kappaM);



%%

rgbface = 0.9;
cut1 = 10;
cut2 = 45;
cut3 = 120;
cut4 = 120;

figure(1)
close(1)
x0=10;
y0=10;
width=500;
height=600;
set(gcf,'position',[x0,y0,width,height])


subplot(3,1,1)
hold on
area([0,cut1,cut1,0],[1e-7,1e-7,10^15,10^15],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-7,1e-7,10^10,10^10],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,150,150,cut4],[1e-7,1e-7,10^15,10^15],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
semilogy(tset,biol(:,1),'LineWidth',2,'Color',Vcol)
semilogy(tset,biol(:,2),'LineWidth',2,'Color',Pcol)
semilogy(tset,biol(:,3),'LineWidth',2,'Color',Mcol)
xlabel('Time')
ylabel('Amount of Biomass')
legend('Vacuoles','Plastids','Growth Machinery','Location','South','Orientation','Horizontal')
set(gca,'FontSize',14,'Yscale','log')
ylim([1e-2,13])
xlim([min(tset),max(tset)])
box on

subplot(3,1,2)
hold on
area([0,cut1,cut1,0],[1e-7,1e-7,10^5,10^5],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-7,1e-7,10^5,10^5],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,150,150,cut4],[1e-7,1e-7,10^5,10^5],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
plot(tset,alphaset(:,1),'LineWidth',2,'Color',Vcol)
hold on
plot(tset,alphaset(:,2),'LineWidth',2,'Color',Pcol)
plot(tset,alphaset(:,3),'LineWidth',2,'Color',Mcol)
xlabel('Time')
ylabel('Proportion Investment')
legend('\alpha_V','\alpha_P','\alpha_M','Location','NorthEast','Orientation','Horizontal')
set(gca,'FontSize',14)
ylim([0,1])
xlim([min(tset),max(tset)])
box on

subplot(3,1,3)
hold on
yyaxis left
area([0,cut1,cut1,0],[4,4,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-7,1e-7,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,300,300,cut4],[1e-7,1e-7,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
plot(tset,biol(:,4),'LineWidth',2)
ylabel('Resource Availability')
ylim([7.998e5,8.e5])
yyaxis right
plot(tset,biol(:,5),'LineWidth',2)
xlabel('Time')
legend('Bacteria','Inorg. Nutrients','Location','SouthEast','Orientation','Vertical')
set(gca,'FontSize',14)
ylim([0,10.1])
xlim([min(tset),max(tset)])
box on


%%


rgbface = 0.9;
cut1 = 10;
cut2 = 45;
cut3 = 120;
cut4 = 120;

figure(1)
close(1)
x0=10;
y0=10;
width=500;
height=600;
set(gcf,'position',[x0,y0,width,height])

subplot(3,1,1)
hold on
area([0,cut1,cut1,0],[1e-2,1e-2,10^15,10^15],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-2,1e-2,10^10,10^10],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,max(tset),max(tset),cut4],[1e-2,1e-2,10^15,10^15],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
semilogy(tset,biol(:,1),'LineWidth',2,'Color',Vcol)
semilogy(tset,biol(:,2),'LineWidth',2,'Color',Pcol)
semilogy(tset,biol(:,3),'LineWidth',2,'Color',Mcol)
xlabel('Time')
ylabel('Amount of Biomass')
legend('Vacuoles','Plastids','Growth Machinery','Location','East','Orientation','Vertical')
set(gca,'FontSize',14,'Yscale','log')
ylim([1e-2,10^5])
xlim([min(tset),max(tset)])
box on

subplot(3,1,2)
hold on
area([0,cut1,cut1,0],[1e-7,1e-7,10^5,10^5],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-7,1e-7,10^5,10^5],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,max(tset),max(tset),cut4],[1e-7,1e-7,10^5,10^5],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
plot(tset,alphaset(:,1),'LineWidth',2,'Color',Vcol)
hold on
plot(tset,alphaset(:,2),'LineWidth',2,'Color',Pcol)
plot(tset,alphaset(:,3),'LineWidth',2,'Color',Mcol)
xlabel('Time')
ylabel('Proportion Investment')
legend('\alpha_V','\alpha_P','\alpha_M','Location','East','Orientation','Vertical')
set(gca,'FontSize',14)
ylim([0,1])
xlim([min(tset),max(tset)])
box on

subplot(3,1,3)
hold on
yyaxis left
area([0,cut1,cut1,0],[4,4,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-7,1e-7,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,300,300,cut4],[1e-7,1e-7,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
plot(tset,biol(:,4),'LineWidth',2)
ylabel('Resource Availability')
ylim([4e5,8.1e5])
yyaxis right
plot(tset,biol(:,5),'LineWidth',2)
xlabel('Time')
legend('Bacteria','Inorg. Nutrients','Location','SouthEast','Orientation','Vertical')
set(gca,'FontSize',14)
ylim([0,10.1])
xlim([min(tset),max(tset)])
box on

%%

figure(2)
close(2)
figure(2)
plot(biol(:,4),biol(:,5),'LineWidth',2,'Color','k')
hold on
plot(biol(1:101,4),biol(1:101,5),'LineWidth',4,'Color','k')
xlabel('Bacteria')
ylabel('Inorganic nutrients')
set(gca,'FontSize',14)

%% Three-stage (bang-bang)

% Parameters
L0 = 50;%1000;
I0 = 10;%0; %10
B0 = .8e6;%1e6; 

% Respiratory costs
r = 1; %0.1#0.01

% Uptakes
yGM = 1;
uCL = 0.01;%0.01*2;
uNI = 1;
attack = 0.000003;
f = 1; % conversion efficiency of bacterial C to mixotroph C
uCB = attack*f;
uNB = uCB/10;%5*attack*f;


% Stoichiometries
qC = 1;
qN = 1;
qG = 1;

% Dilution rate of the chemostat
D = 0.1;

% Absorptivities of chemostat components
kappa0 = 0; % base absorptivity of water
kappaI = 0; % absorptivity of inorganic nutrients
kappaB = 0.; %#00001 # per capita absorptivity of bacteria
kappaP = 0.; %#001 # per capita absorptivity of plastids
kappaV = 0.; %#00001 # per capita absorptivity of vacuoles
kappaM = 0.; %#00001 # per capita absorptivity of growth machinery


% Set up initial conditions
L = L0;
I = I0; 
B = B0; 

strats = NaN(3,4);
% Strict phagotrophy
alpha_til_V = max([(qG*yGM+qC*r)/(qC*uCB*B + qG*yGM),(qG*yGM)/(qN*uNB*B+qG*yGM)]);
alpha_til_P = 0;
alpha_til_M = 1 - alpha_til_V - alpha_til_P;
g_til = qG*yGM*alpha_til_M; %growth rate of strict phagotroph
strats(1,1) = alpha_til_V;
strats(1,2) = alpha_til_P;
strats(1,3) = alpha_til_M;
strats(1,4) = g_til;

% Strict phototrophy
alpha_bar_V = 0;
alpha_bar_P = max([(qG*yGM+qC*r)/(qC*uCL*L+qG*yGM),qG*yGM/(qN*uNI*I+qG*yGM)]);
alpha_bar_M = 1-alpha_bar_P;
g_bar = qG*yGM*alpha_bar_M; % growth rate of strict phototroph
strats(2,1) = alpha_bar_V;
strats(2,2) = alpha_bar_P;
strats(2,3) = alpha_bar_M;
strats(2,4) = g_bar;

% Mixotrophy
term.a = (qN*uNB*B-uCB*qC*B)/(qC*uCL*L-qN*uNI*I);
term.b = (qG*yGM+uCB*qC*B)/(qG*yGM+qC*uCL*L);
term.c = (qG*yGM+qC*r)/(qG*yGM+qC*uCL*L);
term.d = (qC*r)/(qC*uCL*L-qN*uNI*I);
alpha_star_V = (term.c-term.d)/(term.a+term.b); 
alpha_star_P = (qG*yGM*(1-alpha_star_V)+qC*r-qC*uCB*B*alpha_star_V)/(qG*yGM+qC*uCL*L);
alpha_star_M = 1 - alpha_star_V - alpha_star_P;
g_star = qG*yGM*alpha_star_M;
strats(3,1) = alpha_star_V;
strats(3,2) = alpha_star_P;
strats(3,3) = alpha_star_M;
strats(3,4) = g_star;

strats_simplify = strats(strats(:,1)>=0,:);
strats_simplify = strats_simplify(strats_simplify(:,2)>=0,:);
alphas = strats_simplify(strats_simplify(:,4)==max(strats_simplify(:,4)),:);

ic = [alphas(1:3),B0,I0];
tset = linspace(0,250,5000);
%tset2 = linspace(0,150,1000);

c = 1;%3;

% Round 1: original simulation
[Lset,alphaset,biol] = MOCHAchemostat(tset,ic,D,L0,I0,B0,r,yGM,uCL,uNI,uCB,uNB,qC,qN,qG,attack,kappa0,kappaI,kappaB,kappaP,kappaV,kappaM);


%%

rgbface = 0.9;
cut1 = 10;
cut2 = 15;
cut3 = 60;
cut4 = 120;

rgbface = 0.9;
cut1 = 8;
cut2 = 15;
cut3 = 70;
cut4 = 125;

figure(1)
close(1)
x0=10;
y0=10;
width=500;
height=600;
set(gcf,'position',[x0,y0,width,height])

subplot(3,1,1)
hold on
area([0,cut1,cut1,0],[1e-2,1e-2,10^15,10^15],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-2,1e-2,10^10,10^10],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,max(tset),max(tset),cut4],[1e-2,1e-2,10^15,10^15],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
semilogy(tset,biol(:,1),'LineWidth',2,'Color',Vcol)
semilogy(tset,biol(:,2),'LineWidth',2,'Color',Pcol)
semilogy(tset,biol(:,3),'LineWidth',2,'Color',Mcol)
xlabel('Time')
ylabel('Amount of Biomass')
legend('Vacuoles','Plastids','Growth Machinery','Location','East','Orientation','Vertical')
set(gca,'FontSize',14,'Yscale','log')
ylim([1e-2,10^5])
xlim([min(tset),max(tset)])
box on

subplot(3,1,2)
hold on
area([0,cut1,cut1,0],[1e-7,1e-7,10^5,10^5],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-7,1e-7,10^5,10^5],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,max(tset),max(tset),cut4],[1e-7,1e-7,10^5,10^5],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
plot(tset,alphaset(:,1),'LineWidth',2,'Color',Vcol)
hold on
plot(tset,alphaset(:,2),'LineWidth',2,'Color',Pcol)
plot(tset,alphaset(:,3),'LineWidth',2,'Color',Mcol)
xlabel('Time')
ylabel('Proportion Investment')
legend('\alpha_V','\alpha_P','\alpha_M','Location','East','Orientation','Vertical')
set(gca,'FontSize',14)
ylim([0,1])
xlim([min(tset),max(tset)])
box on

subplot(3,1,3)
hold on
yyaxis left
area([0,cut1,cut1,0],[4,4,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-7,1e-7,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,300,300,cut4],[1e-7,1e-7,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
plot(tset,biol(:,4),'LineWidth',2)
ylabel('Resource Availability')
ylim([4e5,8.1e5])
yyaxis right
plot(tset,biol(:,5),'LineWidth',2)
xlabel('Time')
legend('Bacteria','Inorg. Nutrients','Location','SouthEast','Orientation','Vertical')
set(gca,'FontSize',14)
ylim([0,10.1])
xlim([min(tset),max(tset)])
box on

%% Semi-opaque strategy lines
figure(1)
close(1)
x0=10;
y0=10;
width=500;
height=600;
set(gcf,'position',[x0,y0,width,height])

rgbface = 0.9;
cut1 = 8;
cut2 = 15;
cut3 = 70;
cut4 = 125;

opacity = 0.3;

figure(1)
subplot(3,1,1)
hold on
area([0,cut1,cut1,0],[1e-2,1e-2,10^15,10^15],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-2,1e-2,10^10,10^10],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,max(tset),max(tset),cut4],[1e-2,1e-2,10^15,10^15],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
semilogy(tset,biol(:,1),'LineWidth',2,'Color',Vcol)
semilogy(tset,biol(:,2),'LineWidth',2,'Color',Pcol)
semilogy(tset,biol(:,3),'LineWidth',2,'Color',Mcol)
xlabel('Time')
ylabel('Amount of Biomass')
legend('Vacuoles','Plastids','Growth Machinery','Location','East','Orientation','Vertical')
set(gca,'FontSize',14,'Yscale','log')
ylim([1e-2,10^5])
xlim([min(tset),max(tset)])
box on

subplot(3,1,2)
hold on
area([0,cut1,cut1,0],[1e-7,1e-7,1,1],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-7,1e-7,1,1],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,300,300,cut4],[1e-7,1e-7,1,1],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
p1 = plot(tset,alphaset(:,1),'LineWidth',2,'Color',Vcol,'HandleVisibility','off');
p1.Color(4) = opacity;
p2 = plot(tset,alphaset(:,2),'LineWidth',2,'Color',Pcol,'HandleVisibility','off');
p3 = plot(tset,alphaset(:,3),'LineWidth',2,'Color',Mcol,'HandleVisibility','off');
p2.Color(4) = opacity;
p3.Color(4) = opacity;
sz = 7;
scatter(tset,alphaset(:,1),sz,Vcol,'filled')
scatter(tset,alphaset(:,2),sz,Pcol,'filled')
scatter(tset,alphaset(:,3),sz,Mcol,'filled')
xlabel('Time')
ylabel('Proportion Investment')
legend('\alpha_V','\alpha_P','\alpha_M','Location','East','Orientation','Vertical')
set(gca,'FontSize',14)
ylim([0,1])
xlim([min(tset),max(tset)])
box on

subplot(3,1,3)
hold on
yyaxis left
area([0,cut1,cut1,0],[1e-7,1e-7,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut2,cut3,cut3,cut2],[1e-7,1e-7,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
area([cut4,300,300,cut4],[1e-7,1e-7,10^6,10^6],'HandleVisibility','off','FaceColor',[rgbface,rgbface,rgbface],'LineStyle','none')
plot(tset,biol(:,4),'LineWidth',2)
ylabel('Resource Availability')
ylim([4e5,8.1e5])
yyaxis right
plot(tset,biol(:,5),'LineWidth',2)
xlabel('Time')
legend('Bacteria','Inorg. Nutrients','Location','SouthEast','Orientation','Vertical')
set(gca,'FontSize',14)
ylim([0,10.1])
xlim([min(tset),max(tset)])
box on

%% Investigating bang-bang response

timepoint = 200; 
% Set up initial conditions
L = L0*exp(-kappa0 - kappaV*biol(timepoint,1) - kappaB*biol(timepoint,4) - kappaM*biol(timepoint,3) - kappaI*biol(timepoint,5) - kappaP*biol(timepoint,2));
        
I = biol(timepoint,5); 
B = biol(timepoint,4); 

strats = NaN(3,4);
% Strict phagotrophy
alpha_til_V = max([(qG*yGM+qC*r)/(qC*uCB*B + qG*yGM),(qG*yGM)/(qN*uNB*B+qG*yGM)]);
alpha_til_P = 0;
alpha_til_M = 1 - alpha_til_V - alpha_til_P;
g_til = qG*yGM*alpha_til_M; %growth rate of strict phagotroph
strats(1,1) = alpha_til_V;
strats(1,2) = alpha_til_P;
strats(1,3) = alpha_til_M;
strats(1,4) = g_til;

% Strict phototrophy
alpha_bar_V = 0;
alpha_bar_P = max([(qG*yGM+qC*r)/(qC*uCL*L+qG*yGM),qG*yGM/(qN*uNI*I+qG*yGM)]);
alpha_bar_M = 1-alpha_bar_P;
g_bar = qG*yGM*alpha_bar_M; % growth rate of strict phototroph
strats(2,1) = alpha_bar_V;
strats(2,2) = alpha_bar_P;
strats(2,3) = alpha_bar_M;
strats(2,4) = g_bar;

% Mixotrophy
term.a = (qN*uNB*B-uCB*qC*B)/(qC*uCL*L-qN*uNI*I);
term.b = (qG*yGM+uCB*qC*B)/(qG*yGM+qC*uCL*L);
term.c = (qG*yGM+qC*r)/(qG*yGM+qC*uCL*L);
term.d = (qC*r)/(qC*uCL*L-qN*uNI*I);
alpha_star_V = (term.c-term.d)/(term.a+term.b); 
alpha_star_P = (qG*yGM*(1-alpha_star_V)+qC*r-qC*uCB*B*alpha_star_V)/(qG*yGM+qC*uCL*L);
alpha_star_M = 1 - alpha_star_V - alpha_star_P;
g_star = qG*yGM*alpha_star_M;
strats(3,1) = alpha_star_V;
strats(3,2) = alpha_star_P;
strats(3,3) = alpha_star_M;
strats(3,4) = g_star;

strats_simplify = strats(strats(:,1)>=0,:);
strats_simplify = strats_simplify(strats_simplify(:,2)>=0,:);
alphas = strats_simplify(strats_simplify(:,4)==max(strats_simplify(:,4)),:);


%%

