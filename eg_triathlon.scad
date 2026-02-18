/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <die.scad>
include <permute.scad>

/* triathlon training? */
die(25, "line", permute(["SWIM", "BIKE", "RUN"]), font = "VAGRounded BT:style=Regular", vspace = 0.9);
