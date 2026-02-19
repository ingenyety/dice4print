/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <dice4print/die.scad>
include <dice4print/permute.scad>

$color_main = "tomato";
$color_design = "sienna";
$color_cut = undef;

/* triathlon training? */
die(25, "3x2u", permute(["SWIM", "BIKE", "RUN"]), font = "VAGRounded BT:style=Regular", vspace = 0.9);
