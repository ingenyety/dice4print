/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <dice4print/die.scad>
include <dice4print/permute.scad>

$color_main = "antiquewhite";
$color_design = "coral";
$color_cut = "orange";

/* another permutation example */
die(25, "3x2u",  permute(["red", "yellow", "blue"]), vspace = 0.8, font = "VAGRounded BT:style=Regular");
