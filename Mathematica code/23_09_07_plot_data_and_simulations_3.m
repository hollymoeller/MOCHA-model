(* ::Package:: *)

(*the relations between data quantities and model quantities*)
measurestofunc={
"chl.to.C"->wP  \[Alpha]P,
"attack.per.C.per.day.FR.I"->wV \[Alpha]V,
"P_I.perC"->wPL \[Alpha]P light,
"graz.per.C"-> wV \[Alpha]V B,
"Growth.Rate"->g[matrix,\[Alpha]]};
(*maximum light level in experiments (for plotting)*)
maxlight=150;
(*some style for plotting*)
thickness=Thickness[.01];
labelstyle=22;
style={PlotRangeClipping->False,PlotRange->Full,AxesOrigin->{0,0},LabelStyle->labelstyle,PlotStyle->{ColorData[97][1],thickness}};
(*plot a simulation over the light gradient. The quantitiy measure is plotted. The model uses the parameters pars. The options are for the plot styles.*)
simuplot[measure_,pars_,options_]:=Plot[(measure/.measurestofunc/.(\[Alpha]opt[matrix/.light->light]/.pars))/.pars/.light->light,{light,0,1.1 maxlight},Evaluate@options,PlotLabel->measure,Evaluate@style];
(*a test - note that other packages need to be loaded*)
(*testvals={B-> 10^6.,uCB\[Rule]0.2 10^-6,yGM\[Rule]4.,vNB\[Rule]0.7 10^-6,uCL\[Rule]0.03,wPL\[Rule]0.02,wV\[Rule]2. 10^-7,wP\[Rule]40,vNP\[Rule]0,DIN->0,r->.1};
simuplot["graz.per.C",testvals,{}]*)


(*show data and simulation together of light gradient*)
datANDsimuPlotTogether[strains_,pars_,measure_,options_]:=Show[{
datplot[strains,measure,options],
simuplot[measure,pars,options]},PlotRangeClipping->True,PlotRange->({{0,1.1Max[#[[All,1]]]},{0,Full}}&@Flatten[Table[getdataLight[measure,strain],{strain,strains}],1])];


(*colors for plotting the different quantities*)
VPSColors=RGBColor@@#&/@({{168,68,151},{123,188,73},{231,186,96}}/255);
measureColors=
{
"chl.to.C"->VPSColors[[2]],
"attack.per.C.per.day.FR.I"->VPSColors[[1]],
"Growth.Rate"->Black,
"P_I.perC"->VPSColors[[2]],
"graz.per.C"->VPSColors[[1]]
};


(*plot the optimal investment proportions \[Alpha] as a function of light*)
\[Alpha]Styles={AbsoluteThickness[4],#,Opacity[.8]}&/@VPSColors;
\[Alpha]ANDjStyle={PlotStyle->\[Alpha]Styles,PlotRangeClipping->False,AxesOrigin->{0,0},ImagePadding->{{30,50},{10,25}},Ticks->{None,Automatic},LabelStyle->labelstyle,ImageSize->Medium,Exclusions->None};
\[Alpha]Style=Join[{PlotStyle->\[Alpha]Styles},\[Alpha]ANDjStyle];
jPlotLmax=120;
jPlotBmax=2.2 10^6;
\[Alpha]plot[pars_,X_,maxX_,options_]:=Module[{\[Alpha]s,measures},
\[Alpha]s:=(\[Alpha]/.\[Alpha]opt[matrix/.(pars/.{(X->_)->Nothing})]);
Plot[{\[Alpha]s[[1]],\[Alpha]s[[2]],\[Alpha]s[[3]]},{X,0,maxX},Evaluate@options,Evaluate @\[Alpha]Style,PlotRange->{0,1.05}]];


(*create a plot panel for a given strain*)
traitnames={
"chl.to.C"->"Chlorophyll",
"attack.per.C.per.day.FR.I"->"Attack rate",
"Growth.Rate"->"Growth rate",
"P_I.perC"->"Photosynthesis",
"graz.per.C"->"Grazing"
};
NoTickLabels={Directive[FontOpacity -> 0]};
\[Alpha]Legend=Grid[Table[{Plot[.5,{x,0,1},PlotRange->{0,1},ImageSize->20,PlotStyle->{AbsoluteThickness[4],VPSColors[[i]]},Axes->None],Style[{"\!\(\*SubscriptBox[\(\[Alpha]\), \(V\)]\)","\!\(\*SubscriptBox[\(\[Alpha]\), \(P\)]\)","\!\(\*SubscriptBox[\(\[Alpha]\), \(M\)]\)"}[[i]],FontFamily->"Arial",20]},{i,3}],Spacings->{1,1},Alignment->Center];
Add\[Alpha]Legend={Epilog->Inset[\[Alpha]Legend,{200,.62}]};
padding["min"]={{1,2},{10,9}};
padding["left"]={{75,0},{0,0}};
padding["right"]={{0,75},{0,0}};
padding["bottom"]={{0,0},{55,0}};
padding["total"]=Sum[padding[x],{x,{"min","left","right","bottom"}}];
imageSize["max"]={360,230};
imageSize["min"]={360,230}-Total/@padding["total"];
cp=ResourceFunction["CombinePlots"];
plotChoice[strains_,parsToPlot_,Ranges_,Paddings_]:=
Module[{
attackscale=10^6,
simuplotshort,
datplotShort,
imagesize=(imageSize["min"]+Total/@Paddings),
imagePadding=None
},
simuplotshort[trait_,options_,scale_,xlabel_]:=simuplot[scale trait,parsToPlot,{options,PlotRange->(trait/.Ranges),Frame->{{True,True},{True,False}},FrameTicksStyle->{{trait/.measureColors,Automatic},{Automatic,Automatic}},PlotStyle->{trait/.measureColors,Thickness[.02]},PlotLabel->None,FrameLabel->{{Style[trait/.traitnames,trait/.measureColors],None},{xlabel,None}}}];
datplotShort[trait_,options_,scale_]:=datplot[strains,scale trait,{PlotStyle->{trait/.measureColors},PlotRange->(trait/.Ranges)}];
Grid[{#}&/@{"",Style[Row[{"Strain: ",If[Length[strains]==1,strains[[1]],"all"]}],labelstyle,FontFamily->"Arial"],
\[Alpha]plot[parsToPlot,light,1.1 maxlight,{FrameTicksStyle -> {{Automatic,Automatic},{NoTickLabels,Automatic}},ImageSize->imagesize,ImagePadding->Paddings,Frame->{{True,True},{True,False}},FrameLabel->{{"\[Alpha]",None},{None,None}},Add\[Alpha]Legend}],
Show[{
cp[
simuplotshort["chl.to.C",{FrameTicksStyle -> {{"chl.to.C"/.measureColors,Automatic},{NoTickLabels,Automatic}}},1,None],
simuplotshort["attack.per.C.per.day.FR.I",{FrameTicksStyle -> {{"attack.per.C.per.day.FR.I"/.measureColors,Automatic},{NoTickLabels,Automatic}}},attackscale,None],
"AxesSides"->"TwoY"
],
cp[
datplotShort["chl.to.C",{},1],
datplotShort["attack.per.C.per.day.FR.I",{},attackscale],
"AxesSides"->"TwoY"
]
},ImagePadding->Paddings,ImageSize->imagesize],
Show[{
cp[

simuplotshort["P_I.perC",{FrameTicksStyle -> {{"P_I.perC"/.measureColors,Automatic},{NoTickLabels,Automatic}}},1,None],
simuplotshort["graz.per.C",{FrameTicksStyle -> {{"graz.per.C"/.measureColors,Automatic},{NoTickLabels,Automatic}}},1,None],
"AxesSides"->"TwoY"
],

cp[
datplotShort["P_I.perC",{},1],
datplotShort["graz.per.C",{},1],
"AxesSides"->"TwoY"
]
},ImagePadding->Paddings,ImageSize->imagesize]
,
Show[{
simuplotshort["Growth.Rate",{ AxesOrigin->{0,("Growth.Rate"/.Ranges)[[1]]},ImagePadding->(Paddings+padding["bottom"]),ImageSize->(imagesize+Total/@padding["bottom"])},1,"Light"],
datplotShort["Growth.Rate",{},1]
}]
},Alignment->Center]];
