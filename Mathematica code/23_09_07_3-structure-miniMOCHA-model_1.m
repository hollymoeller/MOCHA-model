(* ::Package:: *)


j[f_,\[Alpha]_]:=f . \[Alpha];
g[f_,\[Alpha]_]:=Min[Flatten[j[f,\[Alpha]]]];
\[Alpha]opt2x2[f_]:={\[CapitalAlpha][1]->1-#,\[CapitalAlpha][2]->#}&@\!\(\*
TagBox[GridBox[{
{"\[Piecewise]", GridBox[{
{"0", 
RowBox[{
RowBox[{"(", 
RowBox[{
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "1"}], "]"}], "]"}], ">=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "2"}], "]"}], "]"}]}], "\[And]", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "1"}], "]"}], "]"}], ">=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "2"}], "]"}], "]"}]}]}], ")"}], "\[Or]", "\[IndentingNewLine]", 
RowBox[{"(", 
RowBox[{
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "1"}], "]"}], "]"}], ">=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "2"}], "]"}], "]"}]}], "\[And]", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "1"}], "]"}], "]"}], "<=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "1"}], "]"}], "]"}]}], "\[And]", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "2"}], "]"}], "]"}], "<=", " ", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "2"}], "]"}], "]"}]}]}], ")"}], "\[Or]", "\[IndentingNewLine]", 
RowBox[{"(", 
RowBox[{
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "1"}], "]"}], "]"}], ">=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "2"}], "]"}], "]"}]}], "\[And]", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "1"}], "]"}], "]"}], ">=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "1"}], "]"}], "]"}]}], "\[And]", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "2"}], "]"}], "]"}], "<=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "2"}], "]"}], "]"}]}]}], ")"}]}]},
{"1", 
RowBox[{
RowBox[{"(", 
RowBox[{
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "1"}], "]"}], "]"}], "<=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "2"}], "]"}], "]"}]}], "\[And]", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "1"}], "]"}], "]"}], "<=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "2"}], "]"}], "]"}]}]}], ")"}], "\[Or]", "\[IndentingNewLine]", 
RowBox[{"(", 
RowBox[{
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "1"}], "]"}], "]"}], "<=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "2"}], "]"}], "]"}]}], "\[And]", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "1"}], "]"}], "]"}], "<=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "1"}], "]"}], "]"}]}], "\[And]", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "2"}], "]"}], "]"}], "<=", " ", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "2"}], "]"}], "]"}]}]}], ")"}], "\[Or]", "\[IndentingNewLine]", 
RowBox[{"(", 
RowBox[{
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "1"}], "]"}], "]"}], "<=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "2"}], "]"}], "]"}]}], "\[And]", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "1"}], "]"}], "]"}], ">=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "1"}], "]"}], "]"}]}], "\[And]", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "2"}], "]"}], "]"}], "<=", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "2"}], "]"}], "]"}]}]}], ")"}]}]},
{
RowBox[{
RowBox[{"(", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "1"}], "]"}], "]"}], "-", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "1"}], "]"}], "]"}]}], ")"}], "/", 
RowBox[{"(", 
RowBox[{
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "2"}], "]"}], "]"}], "-", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"1", ",", "1"}], "]"}], "]"}], "+", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "1"}], "]"}], "]"}], "-", 
RowBox[{"f", "[", 
RowBox[{"[", 
RowBox[{"2", ",", "2"}], "]"}], "]"}]}], ")"}]}], "True"}
},
AllowedDimensions->{2, Automatic},
Editable->True,
GridBoxAlignment->{"Columns" -> {{Left}}, "ColumnsIndexed" -> {}, "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
GridBoxItemSize->{"Columns" -> {{Automatic}}, "ColumnsIndexed" -> {}, "Rows" -> {{1.}}, "RowsIndexed" -> {}},
GridBoxSpacings->{"Columns" -> {Offset[0.27999999999999997`], {Offset[0.84]}, Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {Offset[0.2], {Offset[0.4]}, Offset[0.2]}, "RowsIndexed" -> {}},
Selectable->True]}
},
GridBoxAlignment->{"Columns" -> {{Left}}, "ColumnsIndexed" -> {}, "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
GridBoxItemSize->{"Columns" -> {{Automatic}}, "ColumnsIndexed" -> {}, "Rows" -> {{1.}}, "RowsIndexed" -> {}},
GridBoxSpacings->{"Columns" -> {Offset[0.27999999999999997`], {Offset[0.35]}, Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {Offset[0.2], {Offset[0.4]}, Offset[0.2]}, "RowsIndexed" -> {}}],
"Piecewise",
DeleteWithContents->True,
Editable->False,
SelectWithContents->True,
Selectable->False,
StripWrapperBoxes->True]\);
(*g[{{1,2},{3,.5}},{{.6},{.4}}]*)
(*\[Alpha]opt2x2[{{1,2},{3,.5}}]*)
(*f3x3=Table[Subscript[f, Row[{column,row}]],{column,3},{row,3}]*)
(*f3x3[[{2,3},{1,3}]]//MatrixForm*)


\[Alpha]={\[Alpha]V,\[Alpha]P,\[Alpha]M};
matrix=({
 {uCB B-r,  uCL light-r, -r},
 {vNB B, vNP DIN, 0},
 {0, 0, yGM}
});


\[Alpha]opt3x3NoWaste[f_?(MatrixQ[#]\[And]AllTrue[Flatten@#[[All,2]],NumericQ]&)]:={\[Alpha]V->-((-f[[1,3]] f[[2,2]]-f[[1,2]] f[[3,3]]+f[[2,2]] f[[3,3]])/(f[[1,2]] f[[2,1]]-f[[1,3]] f[[2,1]]-f[[1,1]] f[[2,2]]+f[[1,3]] f[[2,2]]-f[[1,1]] f[[3,3]]+f[[1,2]] f[[3,3]]+f[[2,1]] f[[3,3]]-f[[2,2]] f[[3,3]])),
\[Alpha]P->-((-f[[1,3]] f[[2,1]]-f[[1,1]] f[[3,3]]+f[[2,1]] f[[3,3]])/(-f[[1,2]] f[[2,1]]+f[[1,3]] f[[2,1]]+f[[1,1]] f[[2,2]]-f[[1,3]] f[[2,2]]+f[[1,1]] f[[3,3]]-f[[1,2]] f[[3,3]]-f[[2,1]] f[[3,3]]+f[[2,2]] f[[3,3]])),
\[Alpha]M->-((f[[1,2]] f[[2,1]]-f[[1,1]] f[[2,2]])/(-f[[1,2]] f[[2,1]]+f[[1,3]] f[[2,1]]+f[[1,1]] f[[2,2]]-f[[1,3]] f[[2,2]]+f[[1,1]] f[[3,3]]-f[[1,2]] f[[3,3]]-f[[2,1]] f[[3,3]]+f[[2,2]] f[[3,3]]))};


\[Alpha]opt[f_?(MatrixQ[#]\[And]AllTrue[Flatten@#[[All,2]],NumericQ]&)]:=Module[{sol2x2=\[Alpha]opt2x2[f[[1;;2,1;;2]]]},
If[
g[f[[1;;2,1;;2]],{\[CapitalAlpha][1],\[CapitalAlpha][2]}/.sol2x2]<=0,
{\[Alpha]V->\[CapitalAlpha][1],\[Alpha]P->\[CapitalAlpha][2],\[Alpha]M->0}/.sol2x2,
Module[{
gPart,limitingResource,bestAloneStrategyAndStructure,bestAloneStructure,bestAloneStrategy,addOtherStructureBoolean
},
Table[Table[
Module[{fPart=f[[{resource,3},{structure,3}]]},
gPart[structure,resource]={#,g[fPart,{\[CapitalAlpha][1],\[CapitalAlpha][2]}/.#]}&@\[Alpha]opt2x2[fPart]],{resource,2}]
,{structure,2}];
bestAloneStrategyAndStructure=Sort[Table[Join[Sort[Table[gPart[structure,resource],{resource,2}],#1[[2]]<#2[[2]]&][[1]],{structure}],{structure,2}],#1[[2]]>#2[[2]]&][[1]];
bestAloneStructure=bestAloneStrategyAndStructure[[3]];
bestAloneStrategy=Join[bestAloneStrategyAndStructure[[1]]/.{\[CapitalAlpha][1]->(bestAloneStructure/.{1->\[Alpha]V,2->\[Alpha]P}),\[CapitalAlpha][2]->\[Alpha]M},{(bestAloneStructure/.{2->\[Alpha]V,1->\[Alpha]P})->0}];
limitingResource=Sort[Table[Join[gPart[bestAloneStructure,resource],{resource}],{resource,2}],#1[[2]]<#2[[2]]&][[1,3]];
addOtherStructureBoolean=gPart[bestAloneStructure,limitingResource][[2]]<gPart[bestAloneStructure/.{1->2,2->1},limitingResource][[2]];
(*Table[limitingResource[structure]=Sort[Table[Join[gPart[structure,resource],{structure}],{resource,2}],#1[[2]]<#2[[2]]&][[1,3]],{structure,2}]*);
(*Column@{
"gPart:",
Grid@Table[{structure,resource,
gPart[structure,resource]},{structure,2},{resource,2}],
"best alone strategy and structure:",
bestAloneStrategyAndStructure,
"best alone structure:",
bestAloneStructure,
"limitingResource:",
limitingResource,
"best alone strategy",
bestAloneStrategy,
"add Other Structure True/False",
addOtherStructureBoolean,
"final solution",
If[addOtherStructureBoolean,\[Alpha]opt3x3NoWaste[f],bestAloneStrategy]
}*)
If[addOtherStructureBoolean,\[Alpha]opt3x3NoWaste[f],bestAloneStrategy]
]
]
];
