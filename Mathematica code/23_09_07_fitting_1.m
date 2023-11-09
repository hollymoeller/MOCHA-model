(* ::Package:: *)

(*this package contains the functions used to fit the model*)
(*relation between data and model quantities*)
measurestofunc = {
   "chl.to.C" -> wP  \[Alpha]P,
   "attack.per.C.per.day.FR.I" -> wV \[Alpha]V,
   "P_I.perC" -> wPL \[Alpha]P light,
   "graz.per.C" -> wV \[Alpha]V B,
   "Growth.Rate" -> g[matrix, \[Alpha]]};
(*functions to bring data and simulations in right shape for fitting*)
Clear[transposed];
transposed[measure_, data_, 
   pars_?(AllTrue[Flatten@#[[All, 2]], NumericQ] &)] := 
  transposed[measure, data, pars] = 
   Transpose[{measure /. #, 
       measure /. measurestofunc /. \[Alpha]opt[
             matrix /. pars /. light -> #] /. (light -> #) /. 
          pars & /@ (("Light" /. #))} &@data];
Clear[getPosMeasure];
getPosMeasure[strains_,  measure_] := 
  getPosMeasure[strains,  measure] = 
   Select[Flatten[
     Table[getMeasures[strain], {strain, strains}], 1], 
    NumberQ[measure /. #] \[And] NumberQ["Light" /. #] &];
 (*likelihood function for one quantity*)
loglhPART[measure_, pars_?(AllTrue[Flatten@#[[All, 2]], NumericQ] &), 
   strains_] := 
  With[{data = getPosMeasure[strains, measure]},
   -(Length[measure /. data]/2) Log[
      Total[(#[[1]] - #[[2]])^2 & /@ 
        transposed[measure, data, pars]]] /. pars];
(*which quantities should be used for the fitting*)
measuresForFitting = {"chl.to.C", "attack.per.C.per.day.FR.I", "graz.per.C", 
   "Growth.Rate", "P_I.perC"};
(*the joint likelihood function. Data is importet for strains "strains". The paramerts to be fitted, together with their input values are given with the list "parameters"*)
Clear[loglh];
loglh[strains_, 
   parameters_?(AllTrue[Flatten@#[[All, 2]], NumericQ] &)] := 
  Sum[loglhPART[measure, parameters, strains], {measure, 
    measuresForFitting}];
 (*this function does the fitting*)
Clear[fit];
fit[inivals_, strains_, tofit_, constraints_, options_] := 
  fit[inivals, strains, tofit, constraints, options] = 
   Module[{parameter, computation, time}, With[
     {
      parsProtected = Table[parameter[i], {i, Range[Length[tofit]]}],
      parsToInival = 
       Table[parameter[i] -> (tofit[[i]] /. inivals), {i, 
         Range[Length[tofit]]}],
      parsBack = 
       Table[parameter[i] -> tofit[[i]], {i, Range[Length[tofit]]}],
      fixedpars = inivals /. ((# -> _) -> Nothing & /@ tofit),
      parsForward = 
       Table[tofit[[i]] -> parameter[i], {i, Range[Length[tofit]]}]
      },
     time = AbsoluteTiming[computation =
         (NMaximize[
           Join[{loglh[strains, 
              Join[#[[1]] -> #[[2]] & /@ 
                Transpose[{tofit, parsProtected}], fixedpars]]}, 
            constraints /. 
             parsForward], {#, 0.5 # /. parsToInival, 
              2 # /. parsToInival} & /@ parsProtected, 
           Evaluate@options, 
           Method -> {"NelderMead", 
             "PostProcess" -> False}]);];
     {"log likelihood" -> computation[[1]],
      "parameters" -> Join[computation[[2]] /. parsBack, fixedpars],
      "AIC like" ->(*2 Length@tofit*)-2 computation[[1]],
      "Time" -> time[[1]]
      }
     ]];
(*AbsoluteTiming[
 fit[testvals, strains[[3 ;; 3]],  tofitparamters, 
  constraints, {MaxIterations -> 1}]]*)
