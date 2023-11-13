% global simulations of mixotroph strategy for Moeller et al. (2024)

%% Compile driver data %%

% load environmental data
addpath('C:\Users\archi\Box\UCSB Postdoc\MATLAB\')
read_netcdf('C:\Users\archi\Box\UCSB Postdoc\MOCHA\AquaMODIS_PAR\annual_means_2002to2021\AQUA_MODIS.20210101_20211231.L3m.YR.PAR.x_par.nc')
load('C:\Users\archi\Box\UCSB Postdoc\MOCHA\Bacteria_Darwin.mat')
bacteria(bacteria == 0) = NaN;
bacteria = bacteria*12.011*1e6; % convert units from mmol/m3 to cells/ml (assume 10 fgC/cell)
B = bacteria(:,:,1);

% interpolate par data to bacteria data resolution (Darwin grid)
lon(lon<0) = lon(lon<0) + 360;
[lon, sorti] = sort(lon);
par = par(sorti,:);
parinterp = interp2(lat, lon, par, Y, X');
parinterp = 1e6.*parinterp./86400; % convert units from E/m^2/d to uE/m^2/s
L = parinterp;

% filter PAR for photo-saturation
L(L > 300) = 300;

%% Inter-strain variance %%

shts = {'strains=all bacts={X}', 'strains={584} bacts={X}', 'strains={590} bacts={X}', 'strains={1148} bacts={X}', 'strains={1150} bacts={X}',...
    'strains={1392} bacts={X}', 'strains={1393} bacts={X}', 'strains={2951} bacts={X}', 'strains={1391} bacts={X}'};
alpha = NaN(length(X), length(Y), 3, length(shts));
for s = 1:9
    % read excel file
    p = readtable('C:\Users\archi\Box\UCSB Postdoc\MOCHA\MOCHA-parameters.xls', 'sheet', shts{s}, 'range', 'B1:B14');
    uCB = p.Var1(1);
    yGM = p.Var1(2);
    uNB = p.Var1(3);
    uCL = p.Var1(4);
    %wPL = p.Var1(5);
    %wV = p.Var1(6);
    %wP = p.Var1(7);
    uNI = p.Var1(8);
    I = p.Var1(9);
    r = p.Var1(10);
    %B = p.Var1(11);
    qC = p.Var1(12);
    qG = p.Var1(13);
    %qN = p.Var1(14);
    qN = 10;
    % Optimization Algorithm
    for x = 1:length(X)
        for y = 1:length(Y)
            % Resource-specific growth rates (used in edge cases)
            atil_V = max([(qG*yGM + qC*r)/(qC*uNB*B(x,y) + qG*yGM); qG*yGM/(qN*uNB*B(x,y) + qG*yGM)]);
            gcv = qC*(uCB*B(x,y)*atil_V - r);
            gnv = qN*uNB*B(x,y)*atil_V;
            atil_P = max([(qG*yGM + qC*r)/(qC*uCL*L(x,y) + qG*yGM); qG*yGM/(qN*uNI*L(x,y) + qG*yGM)]);
            gcp = qC*(uCL*L(x,y)*atil_P - r);
            gnp = qN*uNI*I*atil_P;
            % Case 1: Strict Phagotrophy
            if uCB*B(x,y) > uCL*L(x,y) && uNB*B(x,y) > uNI*I
                astar = [atil_V, 0, 1-atil_V];
            elseif gcv > gnv && gcp > gnp && uNB*B(x,y) > uNI*I
                astar = [atil_V, 0, 1-atil_V];
            elseif gnv > gcv && gnp > gcp && uCB*B(x,y) > uCL*L(x,y)
                astar = [atil_V, 0, 1-atil_V];
            % Case 2: Strict Photogrophy
            elseif uCL*L(x,y) > uCB*B(x,y) && uNI*I > uNB*B(x,y)
                astar = [0, atil_P, 1 - atil_P];
            elseif gcv > gnv && gcp > gnp && uNI*I > uNB*B(x,y)
                astar = [0, atil_P, 1 - atil_P];
            elseif gnv > gcv && gnp > gcp && uCL*L(x,y) > uCB*B(x,y)
                astar = [0, atil_P, 1 - atil_P];
            % Case 3: Mixotroph
            else
                terma = (qN*uNB*B(x,y) - uCB*qC*B(x,y))/(qC*uCL*L(x,y) - qN*uNI*I);
                termb = (qG*yGM + uCB*qC*B(x,y))/(qG*yGM + qC*uCL*L(x,y));
                termc = (qG*yGM + qC*r)/(qG*yGM + qC*uCL*L(x,y));
                termd = (qC*r)/(qC*uCL*L(x,y) - qN*uNI*I);
                alpha_V = (termc - termd)/(terma + termb);
                alpha_P = (qG*yGM*(1 - alpha_V)+qC*r - qC*uCB*B(x,y)*alpha_V)/(qG*yGM + qC*uCL*L(x,y));
                astar = [alpha_V, alpha_P, 1 - (alpha_V + alpha_P)];
            end
            alpha(x,y,:,s) = astar;
        end
    end
end

%% Construct figure %%

addpath 'C:\Users\archi\Box\UCSB Postdoc\MATLAB\ternaryplot'
add_ternary_paths

% figure settings
fs = 20; % font size

figure('position', [94 175 2183 1090])
t = tiledlayout(6, 9, 'tilespacing', 'tight');

ax(1) = nexttile(7,[2 3]);
plot_geodata(X, Y, alpha(:,:,1,1), [-90 90], [0 360], 'behrmann')
caxis([0 1])
colorbar
vcm = [linspace(1, 168/255); linspace(1, 68/255); linspace(1, 151/255)]';
colormap(ax(1),vcm)
title('Vacuoles, \alpha_V', 'fontweight', 'normal')
set(ax(1), 'fontsize', fs)

ax(2) = nexttile(25, [2 3]);
plot_geodata(X, Y, alpha(:,:,2,1), [-90 90], [0 360], 'behrmann')
pcm = [linspace(1, 123/255); linspace(1, 188/255); linspace(1, 73/255)]';
caxis([0 0.4])
colormap(ax(2),pcm)
colorbar
title('Plastids, \alpha_P', 'fontweight', 'normal')
set(ax(2), 'fontsize', fs)

ax(3) = nexttile(43, [2 3]);
plot_geodata(X, Y, alpha(:,:,3,1), [-90 90], [0 360], 'behrmann')
mcm = [linspace(1, 231/255); linspace(1, 186/255); linspace(1, 96/255)]';
caxis([0 1])
colormap(ax(3),mcm)
colorbar
title('Growth machinery, \alpha_M', 'fontweight', 'normal')
set(ax(3), 'fontsize', fs)

ax(4) = nexttile(1, [2 3]);
plot_geodata(X, Y, parinterp, [-90 90], [0 360], 'behrmann')
colormap(ax(4), gray)
caxis([0 600])
colorbar('westoutside')
title('PAR (\muE m^{-2} s^{-1})', 'fontweight', 'normal')
set(ax(4), 'fontsize', fs)

ax(5) = nexttile(4, [2 3]);
plot_geodata(X, Y, log10(bacteria(:,:,1)), [-90 90], [0 360], 'behrmann')
colormap(ax(5), gray)
caxis([5 8])
cb = colorbar('westoutside');
set(cb, 'Ticks', 5:8)
set(cb, 'TickLabels', {'10^5', '10^6', '10^7', '10^8'})
title('Bacteria (cells mL^{-1})', 'fontweight', 'normal')
set(ax(5), 'fontsize', fs)

ax(6) = nexttile(19, [4 4]);
[N,Xedges,Yedges] = histcounts2(alpha(:,:,1,1),alpha(:,:,2,1),100); % bin strategies
[b1, b2] = meshgrid(Xedges(1:end-1) + diff(Xedges)/2,Yedges(1:end-1) + diff(Yedges)/2);
vgen  = {'gridspaceunit', 10,... % Number of grid lines
         'ticklinelength', [0.01,0.01,0.01],... % length of tick-lines
         'titlelabels', {'Plastids, \alpha_P','Vacuoles, \alpha_V','Growth machinery, \alpha_M'}}; % custom labels (l,b,r)
vout  = {'LineWidth', 2.0, 'LineStyle', '-', 'Color', 'k'}; % axes outline
vgrid = {'LineStyle',':','LineWidth',0.25, 'Color', [0 0 0]}; % gridlines
vtick_line = {'LineStyle', '-', 'LineWidth', 0.25, 'Color', [0 0 0]}; % ticklines
vtick_label = {'FontWeight','normal', 'FontSize', fs}; % tick labels
vlab  = {'FontWeight','normal', 'FontSize', fs}; % axis labels
Cbar = {'FontWeight','normal','Location', 'westoutside'}; % colorbar
ht = ternary_axes(vgen, vout, vgrid, vtick_line, vtick_label, vlab);
[~,hc] = ternary_scatter3([], 'b', b1(N>0), 'l', b2(N>0), log10(N(N>0)), Cbar);
set(hc, 'position', [0.05 0.11 0.0086 0.5333])
set(hc, 'FontSize', fs)
set(hc, 'Ticks', 0:3)
set(hc, 'TickLabels', {'10^0', '10^1', '10^2', '10^3'})
colormap(ax(6), gray)
handle.link_color = {'title'};
adjust_axis_color(ht,'bottom',[168/255 68/255 151/255]);
adjust_axis_color(ht,'left',[123/255 188/255 73/255]);
adjust_axis_color(ht,'right',[231/255 186/255 96/255]);

ax(7) = nexttile(23);
[N,Xedges,Yedges] = histcounts2(alpha(:,:,1,2),alpha(:,:,2,2),100); % bin strategies
[b1, b2] = meshgrid(Xedges(1:end-1) + diff(Xedges)/2,Yedges(1:end-1) + diff(Yedges)/2);
vgen  = {'gridspaceunit', 2, ... % Number of grid lines
         'ticklinelength', [0,0,0], ... % length of tick-lines
         'titlelabels', {'','',''}}; % custom labels
vout  = {'LineWidth', 2.0, 'LineStyle', '-', 'Color', 'k'}; % axes outline
vgrid = {'LineStyle',':','LineWidth',0.25, 'Color', [0 0 0]}; % gridlines
vtick_line = {'LineStyle', '-', 'LineWidth', 0.25, 'Color', [0 0 0]}; % ticklines
vtick_label = {'Visible', 'off'}; % tick labels
ht = ternary_axes(vgen, vout, vgrid, vtick_line, vtick_label, vlab);
hp = ternary_scatter3([], 'b', b1(N>0), 'l', b2(N>0), log10(N(N>0)), 'none');
set(gcf, 'resize', 'off')
set(gca, 'Position', [0 0 1 1])
set(hp, 'SizeData', 10)
colormap(ax(7), gray)
handle.link_color = {'title'};
adjust_axis_color(ht,'bottom',[168/255 68/255 151/255]);
adjust_axis_color(ht,'left',[123/255 188/255 73/255]);
adjust_axis_color(ht,'right',[231/255 186/255 96/255]);
tx = 0.41;
ty = 0.08;
text(tx, ty, '584', 'FontSize', fs)

ax(8) = nexttile(24);
[N,Xedges,Yedges] = histcounts2(alpha(:,:,1,3),alpha(:,:,2,3),100); % bin strategies
[b1, b2] = meshgrid(Xedges(1:end-1) + diff(Xedges)/2,Yedges(1:end-1) + diff(Yedges)/2);
ht = ternary_axes(vgen, vout, vgrid, vtick_line, vtick_label, vlab);
hp = ternary_scatter3([], 'b', b1(N>0), 'l', b2(N>0), log10(N(N>0)), 'none');
set(hp, 'SizeData', 10)
colormap(ax(8), gray)
handle.link_color = {'title'};
adjust_axis_color(ht,'bottom',[168/255 68/255 151/255]);
adjust_axis_color(ht,'left',[123/255 188/255 73/255]);
adjust_axis_color(ht,'right',[231/255 186/255 96/255]);
text(tx, ty, '590', 'FontSize', fs)

ax(9) = nexttile(32);
[N,Xedges,Yedges] = histcounts2(alpha(:,:,1,4),alpha(:,:,2,4),100); % bin strategies
[b1, b2] = meshgrid(Xedges(1:end-1) + diff(Xedges)/2,Yedges(1:end-1) + diff(Yedges)/2);
ht = ternary_axes(vgen, vout, vgrid, vtick_line, vtick_label, vlab);
hp = ternary_scatter3([], 'b', b1(N>0), 'l', b2(N>0), log10(N(N>0)), 'none');
set(hp, 'SizeData', 10)
colormap(ax(9), gray)
handle.link_color = {'title'};
adjust_axis_color(ht,'bottom',[168/255 68/255 151/255]);
adjust_axis_color(ht,'left',[123/255 188/255 73/255]);
adjust_axis_color(ht,'right',[231/255 186/255 96/255]);
text(tx, ty, '1148', 'FontSize', fs) 

ax(10) = nexttile(33);
[N,Xedges,Yedges] = histcounts2(alpha(:,:,1,5),alpha(:,:,2,5),100); % bin strategies
[b1, b2] = meshgrid(Xedges(1:end-1) + diff(Xedges)/2,Yedges(1:end-1) + diff(Yedges)/2);
ht = ternary_axes(vgen, vout, vgrid, vtick_line, vtick_label, vlab);
hp = ternary_scatter3([], 'b', b1(N>0), 'l', b2(N>0), log10(N(N>0)), 'none');
set(hp, 'SizeData', 10)
colormap(ax(10), gray)
handle.link_color = {'title'};
adjust_axis_color(ht,'bottom',[168/255 68/255 151/255]);
adjust_axis_color(ht,'left',[123/255 188/255 73/255]);
adjust_axis_color(ht,'right',[231/255 186/255 96/255]);
text(tx, ty, '1150', 'FontSize', fs)

ax(11) = nexttile(41);
[N,Xedges,Yedges] = histcounts2(alpha(:,:,1,6),alpha(:,:,2,6),100); % bin strategies
[b1, b2] = meshgrid(Xedges(1:end-1) + diff(Xedges)/2,Yedges(1:end-1) + diff(Yedges)/2);
ht = ternary_axes(vgen, vout, vgrid, vtick_line, vtick_label, vlab);
hp = ternary_scatter3([], 'b', b1(N>0), 'l', b2(N>0), log10(N(N>0)), 'none');
set(hp, 'SizeData', 10)
colormap(ax(11), gray)
handle.link_color = {'title'};
adjust_axis_color(ht,'bottom',[168/255 68/255 151/255]);
adjust_axis_color(ht,'left',[123/255 188/255 73/255]);
adjust_axis_color(ht,'right',[231/255 186/255 96/255]);
text(tx, ty, '1392', 'FontSize', fs) 

ax(12) = nexttile(42);
[N,Xedges,Yedges] = histcounts2(alpha(:,:,1,7),alpha(:,:,2,7),100); % bin strategies
[b1, b2] = meshgrid(Xedges(1:end-1) + diff(Xedges)/2,Yedges(1:end-1) + diff(Yedges)/2);
ht = ternary_axes(vgen, vout, vgrid, vtick_line, vtick_label, vlab);
hp = ternary_scatter3([], 'b', b1(N>0), 'l', b2(N>0), log10(N(N>0)), 'none');
set(hp, 'SizeData', 10)
colormap(ax(12), gray)
handle.link_color = {'title'};
adjust_axis_color(ht,'bottom',[168/255 68/255 151/255]);
adjust_axis_color(ht,'left',[123/255 188/255 73/255]);
adjust_axis_color(ht,'right',[231/255 186/255 96/255]);
text(tx, ty, '1393', 'FontSize', fs) 

ax(13) = nexttile(50);
[N,Xedges,Yedges] = histcounts2(alpha(:,:,1,8),alpha(:,:,2,8),100); % bin strategies
[b1, b2] = meshgrid(Xedges(1:end-1) + diff(Xedges)/2,Yedges(1:end-1) + diff(Yedges)/2);
ht = ternary_axes(vgen, vout, vgrid, vtick_line, vtick_label, vlab);
hp = ternary_scatter3([], 'b', b1(N>0), 'l', b2(N>0), log10(N(N>0)), 'none');
set(hp, 'SizeData', 10)
colormap(ax(13), gray)
handle.link_color = {'title'};
adjust_axis_color(ht,'bottom',[168/255 68/255 151/255]);
adjust_axis_color(ht,'left',[123/255 188/255 73/255]);
adjust_axis_color(ht,'right',[231/255 186/255 96/255]);
text(tx, ty, '2951', 'FontSize', fs)

ax(14) = nexttile(51);
[N,Xedges,Yedges] = histcounts2(alpha(:,:,1,9),alpha(:,:,2,9),100); % bin strategies
[b1, b2] = meshgrid(Xedges(1:end-1) + diff(Xedges)/2,Yedges(1:end-1) + diff(Yedges)/2);
ht = ternary_axes(vgen, vout, vgrid, vtick_line, vtick_label, vlab);
hp = ternary_scatter3([], 'b', b1(N>0), 'l', b2(N>0), log10(N(N>0)), 'none');
set(hp, 'SizeData', 10)
colormap(ax(14), gray)
handle.link_color = {'title'};
adjust_axis_color(ht,'bottom',[168/255 68/255 151/255]);
adjust_axis_color(ht,'left',[123/255 188/255 73/255]);
adjust_axis_color(ht,'right',[231/255 186/255 96/255]);
text(tx, ty, '1391', 'FontSize', fs) 

%% Save %%

exportgraphics(gcf, 'C:\Users\archi\Box\UCSB Postdoc\MOCHA\global_figure.pdf', 'contenttype', 'vector')
save('mocha_plots')

