/*----------------------------------------------------------------------
Copyright (c) 2020-2026, Philip Nye.

#tabs=4s
----------------------------------------------------------------------*/

include <die.scad>
include <permute.scad>

/* another permutation example */
die(36, "line",  permute(["red", "yellow", "blue"]), vspace = 0.8, font = "VAGRounded BT:style=Regular");
