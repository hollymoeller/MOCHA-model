(* ::Package:: *)

(*this package imports the data and defines basic data plots*)


(*load data from file*)
data = Quiet@
   Import[NotebookDirectory[] <> "Ochromonas_TradeoffFunctions_for_MOCHA.xlsx"];
(*add headers*)
dataset = 
  Dataset[Map[AssociationThread[First[data[[1]]], #] &, 
    Rest[data[[1]]]]];


(*extract data for a given strain*)
getMeasures[strain_] := 
  Normal@dataset[
    Select[#"Strain" == strain &]];
(*all strains in the experiment*)
strains ={584, 590, 1148, 1150, 1392, 1393, 2951, 1391};


(*Extract data for strains "strains". Add possible "condition"s for selecting the data*)
selectDat[strains_,condition_] := 
  Select[Flatten[Table[getMeasures[strain], {strain, strains}],
       1], condition];
(*This function calculates mean values from a dataset "list". The argument "meanKey" is the key over which we collect data (for example a certain light level). The argument "otherKeys" are the keys we want to extract as mean values.*)
meanBy[list_, meanKey_, otherKeys_] := Module[
   {meanKeyValues},
   meanKeyValues = Union[meanKey /. list];
   Table[
    Module[{selectList = Select[list, (meanKey /. #) == key &]},
     Join[{meanKey -> key}, 
      Table[otherKey -> Mean[otherKey /. selectList], {otherKey, 
        otherKeys}]]
     ], {key, meanKeyValues}]
   ];
(*Extract data for a key "measure" and a given "strain". The output list has the format {{Light1, ...},{Light2, ...},...}. Extract only data with a numerical value.*)
getdataLight[measure_, strain_] := 
  Select[{"Light", measure} /. 
    Normal@dataset[
      Select[#"Strain" == 
          strain&]], 
   And @@ (NumericQ[#] & /@ #) &];
(*Plot the data of the measurment "measure" with Light on the x-axis. Choose all strains "strains". Possible style options "options".*)
datplot[strains_, measure_, options_] :=
  ListPlot[
    Flatten[Table[
      getdataLight[measure,strain], {strain, strains}], 
     1], Evaluate@options, PlotLabel -> measure, AxesLabel -> {"L"}, 
   PlotMarkers -> ({Graphics`PlotMarkers[][[1, 1]], 12}), 
   Joined -> False, PlotStyle -> ColorData[97][2]];


(*Example for how to plot data*)
datplot[strains,"P_I.perC", {}]
