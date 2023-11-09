(* ::Package:: *)

(*this package imports the bacteria densities from the data file (depends on strain but not on light)*))*)


bacteriaFit[strains_] := 
  bacteriaFit[strains, 
    bacts] = {B -> 
     Mean[Flatten@
       Table[Union[
         getdataLight["Base.Bact", strain][[All, 2]]], {strain, 
         strains}]]};
(*AbsoluteTiming@Column[bacteriaFit[{#}] & /@ strains]*)
